/**
 * @prettier
 */
import Registry from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/class/Registry"
import int32Generator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/int32"
import int64Generator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/int64"
import floatGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/float"
import doubleGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/double"
import emailGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/email"
import idnEmailGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/idn-email"
import hostnameGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/hostname"
import idnHostnameGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/idn-hostname"
import ipv4Generator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/ipv4"
import ipv6Generator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/ipv6"
import uriGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/uri"
import uriReferenceGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/uri-reference"
import iriGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/iri"
import iriReferenceGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/iri-reference"
import uuidGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/uuid"
import uriTemplateGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/uri-template"
import jsonPointerGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/json-pointer"
import relativeJsonPointerGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/relative-json-pointer"
import dateTimeGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/date-time"
import dateGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/date"
import timeGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/time"
import durationGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/duration"
import passwordGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/password"
import regexGenerator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/regex"

class FormatRegistry extends Registry {
  #defaults = {
    int32: int32Generator,
    int64: int64Generator,
    float: floatGenerator,
    double: doubleGenerator,
    email: emailGenerator,
    "idn-email": idnEmailGenerator,
    hostname: hostnameGenerator,
    "idn-hostname": idnHostnameGenerator,
    ipv4: ipv4Generator,
    ipv6: ipv6Generator,
    uri: uriGenerator,
    "uri-reference": uriReferenceGenerator,
    iri: iriGenerator,
    "iri-reference": iriReferenceGenerator,
    uuid: uuidGenerator,
    "uri-template": uriTemplateGenerator,
    "json-pointer": jsonPointerGenerator,
    "relative-json-pointer": relativeJsonPointerGenerator,
    "date-time": dateTimeGenerator,
    date: dateGenerator,
    time: timeGenerator,
    duration: durationGenerator,
    password: passwordGenerator,
    regex: regexGenerator,
  }

  data = { ...this.#defaults }

  get defaults() {
    return { ...this.#defaults }
  }
}

export default FormatRegistry
