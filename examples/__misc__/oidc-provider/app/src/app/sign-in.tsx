import { StatusBar } from "expo-status-bar";
import { Button, Text, View } from "react-native";
import { useSession } from "../auth";

export default function SignIn() {
  const { signIn, ready, error } = useSession();

  return (
    <View className="flex-1 bg-white dark:bg-black items-center justify-center px-8">
      <Text className="text-4xl font-extrabold text-gray-800 dark:text-white mb-3 tracking-tight">
        🚀 Welcome
      </Text>

      <Text className="text-xl dark:text-white text-gray-700 mb-8 text-center leading-relaxed">
        Sign in with the{" "}
        <Text className="text-blue-500 font-semibold">OIDC provider</Text>
      </Text>

      {/* The guard in _layout swaps to (app) once the session lands. */}
      <Button disabled={!ready} title="Sign in" onPress={() => void signIn()} />

      {error ? <Text className="text-red-500 mt-6 text-center">{error}</Text> : null}

      <StatusBar style="dark" />
    </View>
  );
}
