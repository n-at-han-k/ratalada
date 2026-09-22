import "@/lib/node-globals"

import "@/styles/application.css"

import SwaggerUI from "@/lib/swagger/swagger-ui"

// The document this project generates, embedded by app/index.rb rather than
// fetched: it is already on the page, and a fetch would be a second route the
// document never declared.
const element = document.getElementById("swagger-document")
const spec = element ? JSON.parse(element.textContent!) : undefined

SwaggerUI({
  dom_id: "#swagger",
  ...(spec ? { spec } : {}),
  deepLinking: true,
})
