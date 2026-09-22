/**
 * @prettier
 */
import StandaloneLayoutPlugin from "@/lib/swagger/standalone/plugins/stadalone-layout/index"
import TopBarPlugin from "@/lib/swagger/standalone/plugins/top-bar/index"
import ConfigsPlugin from "@/lib/swagger/plugins/configs/index"
import SafeRenderPlugin from "@/lib/swagger/plugins/safe-render/index"

const StandalonePreset = [
  TopBarPlugin,
  ConfigsPlugin,
  StandaloneLayoutPlugin,
  SafeRenderPlugin({
    fullOverride: true,
    componentList: ["Topbar", "StandaloneLayout", "onlineValidatorBadge"],
  }),
]

export default StandalonePreset
