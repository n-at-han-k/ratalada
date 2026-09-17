# metacontroller

A [Metacontroller](https://metacontroller.github.io/metacontroller/) CompositeController written with ratalada and kube_cluster.

`Website` is a custom resource. For each one, the controller owns a Deployment and a Service. Metacontroller POSTs the `Website` to the webhook in `app.rb`, which answers with the children built from `Kube::Cluster::Standard::DeploymentWithService`. `manifest.rb` emits the CRD, the webhook's own Deployment and Service, and the CompositeController that wires them together.

```sh
bin/dev   # local k3s + registry, metacontroller, this controller, one Website
```

Or run k3s in a [microvm.nix](https://github.com/microvm-nix/microvm.nix) guest instead of the compose container. It forwards 6443, writes `./kubeconfig.yaml`, and pulls `registry:5000` images from the host's port 5000:

```sh
nix run .#k3s-vm        # in one terminal; root login has no password
bin/dev registry        # in another: compose starts only the registry
```

## Verify

```sh
export KUBECONFIG=./kubeconfig.yaml
kubectl get websites,deploy,svc -n default
kubectl patch website hello --type merge -p '{"spec":{"replicas":3}}'
kubectl get deploy hello -w
kubectl delete website hello   # children are garbage-collected
```

## Test the webhook alone

```sh
PORT=8080 bundle exec ruby app.rb &
xh post :8080/sync parent:='{"metadata":{"name":"hello","namespace":"default"},"spec":{"replicas":2}}' children:='{}'
```
