# frozen_string_literal: true

require "kube/cluster/standard"

Standard = Kube::Cluster::Standard
NAMESPACE = "metacontroller"
IMAGE = ENV.fetch("IMAGE", "registry:5000/website-controller:latest")

# Defining the CRD also registers "Website" with the schema, so
# Kube::Cluster["Website"] resolves below.
crd = Standard::CustomResourceDefinition.new(kind: "Website", group: "example.com")

webhook = Standard::DeploymentWithService.new(
  name:      "website-controller",
  namespace: NAMESPACE,
  image:     IMAGE,
  port:      8080,
)

controller = Standard::MetaController::CompositeController.new(
  name:            "website",
  webhook_url:     "http://website-controller.#{NAMESPACE}.svc:8080/sync",
  parent_resource: Kube::Cluster["Website"],
  child_resources: {
    Kube::Cluster["Deployment"] => { updateStrategy: { method: "InPlace" } },
    Kube::Cluster["Service"]    => { updateStrategy: { method: "InPlace" } },
  },
)

puts Kube::Cluster::Manifest.new(crd, webhook, controller).to_yaml
