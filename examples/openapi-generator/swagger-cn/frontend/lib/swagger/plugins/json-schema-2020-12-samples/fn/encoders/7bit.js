import { Buffer } from "buffer"
/**
 * @prettier
 */
const encode7bit = (content) => Buffer.from(content).toString("ascii")

export default encode7bit
