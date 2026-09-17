import * as AuthSession from "expo-auth-session";
import { createContext, use, type PropsWithChildren } from "react";
import { useState } from "react";

const ISSUER = process.env.EXPO_PUBLIC_ISSUER ?? "http://localhost:9292";
const CLIENT_ID = process.env.EXPO_PUBLIC_CLIENT_ID ?? "demo-native";

// Native: acme://redirect (scheme from app.json). Web: <origin>/redirect.
// Both are seeded on the provider's native client.
export const redirectUri = AuthSession.makeRedirectUri({
  scheme: "acme",
  path: "redirect",
});

type Session = { accessToken: string; email?: string };

const AuthContext = createContext<{
  signIn: () => Promise<void>;
  signOut: () => void;
  session: Session | null;
  /** False until discovery and the auth request have loaded. */
  ready: boolean;
  error: string | null;
} | null>(null);

export function useSession() {
  const value = use(AuthContext);
  if (!value) throw new Error("useSession must be wrapped in a <SessionProvider />");
  return value;
}

export function SessionProvider({ children }: PropsWithChildren) {
  const discovery = AuthSession.useAutoDiscovery(ISSUER);
  const [session, setSession] = useState<Session | null>(null);
  const [error, setError] = useState<string | null>(null);

  // usePKCE defaults to true → S256 code_challenge + verifier handled for us,
  // which is what lets this be a public client with no secret to hide.
  const [request, , promptAsync] = AuthSession.useAuthRequest(
    {
      clientId: CLIENT_ID,
      redirectUri,
      responseType: AuthSession.ResponseType.Code,
      scopes: ["openid", "email"],
    },
    discovery,
  );

  return (
    <AuthContext.Provider
      value={{
        session,
        error,
        ready: !!request && !!discovery,
        signOut: () => setSession(null),
        signIn: async () => {
          if (!request || !discovery) return;
          setError(null);

          const response = await promptAsync();
          if (response.type === "error") {
            setError(response.params.error_description ?? response.params.error);
            return;
          }
          if (response.type !== "success") return;

          try {
            const token = await AuthSession.exchangeCodeAsync(
              {
                clientId: CLIENT_ID,
                code: response.params.code,
                redirectUri,
                extraParams: { code_verifier: request.codeVerifier! },
              },
              discovery,
            );
            const claims = await AuthSession.fetchUserInfoAsync(token, discovery);
            setSession({ accessToken: token.accessToken, email: claims.email });
          } catch (e) {
            setError(String(e));
          }
        },
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}
