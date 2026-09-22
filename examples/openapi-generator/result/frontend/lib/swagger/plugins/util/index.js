import { shallowEqualKeys } from "@/lib/swagger/utils/index"
import { sanitizeUrl } from "@/lib/swagger/utils/url"

export default function() {
  return {
    fn: {
      shallowEqualKeys,
      sanitizeUrl,
    }
  }
}
