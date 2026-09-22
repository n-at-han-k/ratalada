import { Buffer } from "buffer"
/**
 * @prettier
 */
const encodeBase64 = (content) => Buffer.from(content).toString("base64")

export default encodeBase64
