import { requestSnippetGenerator_curl_bash, requestSnippetGenerator_curl_cmd, requestSnippetGenerator_curl_powershell } from "@/lib/swagger/plugins/request-snippets/fn"
import * as selectors from "@/lib/swagger/plugins/request-snippets/selectors"
import RequestSnippets from "@/lib/swagger/plugins/request-snippets/request-snippets"

export default () => {
  return {
    components: {
      RequestSnippets
    },
    fn: {
      requestSnippetGenerator_curl_bash,
      requestSnippetGenerator_curl_cmd,
      requestSnippetGenerator_curl_powershell,
    },
    statePlugins: {
      requestSnippets: {
        selectors
      }
    }
  }
}
