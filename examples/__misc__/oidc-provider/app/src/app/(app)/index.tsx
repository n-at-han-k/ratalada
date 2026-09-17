import { StatusBar } from "expo-status-bar";
import { Button, Text, View } from "react-native";
import { useSession } from "../../auth";

export default function Index() {
  const { session, signOut } = useSession();

  return (
    <View className="flex-1 bg-white dark:bg-black items-center justify-center px-8">
      <Text className="text-4xl font-extrabold text-gray-800 dark:text-white mb-3 tracking-tight">
        🚀 Signed in
      </Text>

      <Text className="text-xl dark:text-white text-gray-700 mb-8 text-center leading-relaxed">
        <Text className="text-blue-500 font-semibold">{session?.email ?? "unknown user"}</Text>
      </Text>

      {/* The guard in _layout sends us back to /sign-in. */}
      <Button title="Sign out" onPress={signOut} />

      <StatusBar style="dark" />
    </View>
  );
}
