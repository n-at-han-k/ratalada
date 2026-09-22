/**
 * @prettier
 */
import TopBar from "@/lib/swagger/standalone/plugins/top-bar/components/TopBar"
import Logo from "@/lib/swagger/standalone/plugins/top-bar/components/Logo"
import DarkModeToggle from "@/lib/swagger/standalone/plugins/top-bar/components/DarkModeToggle"

const TopBarPlugin = () => ({
  components: { Topbar: TopBar, Logo, DarkModeToggle },
})

export default TopBarPlugin
