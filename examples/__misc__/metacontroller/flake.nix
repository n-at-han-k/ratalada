{
  description = "Ruby Project";
  inputs = {
    mine.url = "github:n-at-han-k/flake.nix";
    # follows: without it mine drags in a second nixpkgs closure.
    mine.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "nixpkgs";
    utils.url = "github:numtide/flake-utils";
    microvm.url = "github:microvm-nix/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, mine, nixpkgs, utils, microvm }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = mine.lib.${system};
        gems = lib.buildGemset { name = "metacontroller-bundler-env"; src = ./.; };
      in
      {
        devShells.default = lib.mkRubyShell {
          buildInputs = [ gems gems.wrappedRuby pkgs.kubectl ];
        };

        # nix run .#k3s-vm — a NixOS microVM running k3s, in place of the
        # docker-compose cluster. Writes ./kubeconfig.yaml on boot.
        packages.k3s-vm = self.nixosConfigurations.k3s.config.microvm.declaredRunner;
      }
    ) // {
      nixosConfigurations.k3s = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          microvm.nixosModules.microvm
          ({ ... }: {
            system.stateVersion = "25.05";
            networking.hostName = "k3s";
            networking.firewall.allowedTCPPorts = [ 6443 ];
            users.users.root.password = "";

            services.k3s = {
              enable = true;
              role = "server";
              extraFlags = "--write-kubeconfig /output/kubeconfig.yaml --write-kubeconfig-mode 644 --tls-san 127.0.0.1";
            };

            # bin/dev pushes to the host registry on :5000; qemu user
            # networking exposes the host to the guest as 10.0.2.2.
            environment.etc."rancher/k3s/registries.yaml".text = ''
              mirrors:
                "registry:5000":
                  endpoint:
                    - "http://10.0.2.2:5000"
            '';

            microvm = {
              hypervisor = "qemu";
              vcpu = 2;
              mem = 4096;
              interfaces = [{ type = "user"; id = "k3s"; mac = "02:00:00:00:00:01"; }];
              forwardPorts = [{ from = "host"; host.port = 6443; guest.port = 6443; }];
              shares = [
                { tag = "ro-store"; source = "/nix/store"; mountPoint = "/nix/.ro-store"; proto = "9p"; }
                { tag = "output"; source = "."; mountPoint = "/output"; proto = "9p"; }
              ];
              # k3s state; created on first run.
              volumes = [{ image = "k3s-var.img"; mountPoint = "/var"; size = 8192; }];
            };
          })
        ];
      };
    };
}
