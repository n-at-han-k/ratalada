import "../global.css";

import { Stack } from "expo-router";
import * as WebBrowser from "expo-web-browser";
import { SessionProvider, useSession } from "../auth";

// Closes the popup on web after the provider redirects back to /redirect. Lives
// here so it runs whichever route the popup lands on.
WebBrowser.maybeCompleteAuthSession();

export default function Root() {
  return (
    <SessionProvider>
      <RootNavigator />
    </SessionProvider>
  );
}

function RootNavigator() {
  const { session } = useSession();

  return (
    <Stack screenOptions={{ headerShown: false }}>
      <Stack.Protected guard={!!session}>
        <Stack.Screen name="(app)" />
      </Stack.Protected>

      <Stack.Protected guard={!session}>
        <Stack.Screen name="sign-in" />
      </Stack.Protected>
      {/* /redirect stays unguarded: the browser lands there before there is a session. */}
    </Stack>
  );
}
