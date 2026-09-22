/**
 * @prettier
 */
import Registry from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/class/Registry"
import encode7bit from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/encoders/7bit"
import encode8bit from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/encoders/8bit"
import encodeBinary from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/encoders/binary"
import encodeQuotedPrintable from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/encoders/quoted-printable"
import encodeBase16 from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/encoders/base16"
import encodeBase32 from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/encoders/base32"
import encodeBase64 from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/encoders/base64"
import encodeBase64Url from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/encoders/base64url"

class EncoderRegistry extends Registry {
  #defaults = {
    "7bit": encode7bit,
    "8bit": encode8bit,
    binary: encodeBinary,
    "quoted-printable": encodeQuotedPrintable,
    base16: encodeBase16,
    base32: encodeBase32,
    base64: encodeBase64,
    base64url: encodeBase64Url,
  }

  data = { ...this.#defaults }

  get defaults() {
    return { ...this.#defaults }
  }
}

export default EncoderRegistry
