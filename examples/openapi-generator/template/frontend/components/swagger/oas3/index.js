import Callbacks from "@/components/swagger/oas3/callbacks"
import RequestBody from "@/components/swagger/oas3/request-body"
import OperationLink from "@/components/swagger/oas3/operation-link"
import Servers from "@/components/swagger/oas3/servers"
import ServersContainer from "@/components/swagger/oas3/servers-container"
import RequestBodyEditor from "@/components/swagger/oas3/request-body-editor"
import HttpAuth from "@/components/swagger/oas3/auth/http-auth"
import OperationServers from "@/components/swagger/oas3/operation-servers"

export default {
  Callbacks,
  HttpAuth,
  RequestBody,
  Servers,
  ServersContainer,
  RequestBodyEditor,
  OperationServers,
  operationLink: OperationLink,
}
