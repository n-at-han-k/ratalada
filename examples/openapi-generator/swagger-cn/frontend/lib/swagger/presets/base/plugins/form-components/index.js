/**
 * @prettier
 *
 * The seam. swagger-ui never imports a form control directly -- it asks the
 * registry for one by name, and this plugin is what answers. Replacing the
 * answer replaces every control in the app: the auth modal's inputs, the
 * try-it-out textareas, the Execute and Authorize buttons, all of it.
 *
 * So the primitives were deleted from components/swagger/layout-utils.jsx
 * rather than rewritten, and shadcn's are registered under the same names.
 * Container, Col, Row, Link and Collapse stay -- they are layout and
 * behaviour, not form controls, and shadcn has no equivalent.
 */
import { Container, Col, Row, Link, Collapse } from "@/components/swagger/layout-utils"

import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { Select } from "@/components/select"

const FormComponentsPlugin = () => ({
  components: {
    Container,
    Col,
    Row,
    Link,
    Collapse,

    Button,
    Input,
    Select,
    // swagger-ui asks for `TextArea`; shadcn spells it `Textarea`.
    TextArea: Textarea,
  },
})

export default FormComponentsPlugin
