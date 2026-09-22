/**
 * @prettier
 */
import afterLoad from "@/lib/swagger/plugins/versions/after-load"

const VersionsPlugin = () => ({
  afterLoad,
})

export default VersionsPlugin
