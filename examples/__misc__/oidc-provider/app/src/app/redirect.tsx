import { ActivityIndicator, View } from "react-native";

/**
 * Where the provider sends the browser back on web (native uses acme://redirect
 * and never renders this). `maybeCompleteAuthSession()` in _layout closes the
 * popup itself, so this only renders for the moment before that happens.
 */
export default function Redirect() {
  return (
    <View className="flex-1 bg-white dark:bg-black items-center justify-center">
      <ActivityIndicator />
    </View>
  );
}
