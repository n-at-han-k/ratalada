import { Buffer } from "buffer"
/**
 * @prettier
 */
const encodeBinary = (content) => Buffer.from(content).toString("binary")

export default encodeBinary
