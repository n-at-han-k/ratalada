# frozen_string_literal: true

require "ratalada/falcon"
require "json"
require "kube/cluster/standard"


def response(parent)
  status = parent.fetch(:spec, {}).then do |spec|
    {
      replicas: spec.fetch(:replicas, 1),
      image:    spec.fetch(:image, "nginx:alpine"),
      port:     spec.fetch(:port, 80),
    }
  end

  deployment, service = Kube::Cluster::Standard::DeploymentWithService.new(
    name:      parent.dig(:metadata, :name),
    namespace: parent.dig(:metadata, :namespace),
    image:     status[:image],
    port:      status[:port],
  ).map(&:to_h)

  deployment[:spec][:replicas] = status[:replicas]

  {
    status:   status,
    children: [deployment, service],
  }
end

Server.run(host: "0.0.0.0", port: Integer(ENV.fetch("PORT", "8080"))) do |request|
  case request
  in ["POST", "/sync"]
    JSON.parse(request.body, symbolize_names: true).fetch(:parent).then do |parent|
      [ 200, { "content-type" => "application/json" }, [ JSON.generate(response(parent)) ] ]
    end
  end
end
