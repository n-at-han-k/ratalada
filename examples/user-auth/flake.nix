{
  description = "Ratalada Project";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }:
    (utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        gems = pkgs.bundlerEnv {
          name = "ratalada";
          ruby = pkgs.ruby_3_4;
          gemfile  = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset   = ./gemset.nix;
        };

        pnpmDeps = pkgs.fetchPnpmDeps {
          pname = "ratalada";
          version = "0";
          src = ./.;
          fetcherVersion = 4;
          hash = "sha256-DSoaQRCdb9lr/zGPKvHHKPtS9xa2pM+MDAwXWc5P7qk=";
        };

      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkg-config
            pnpmConfigHook
          ];

          inherit pnpmDeps;

          buildInputs = with pkgs; [
            overmind
            tmux
            bundix
            gems
            gems.wrappedRuby
            libyaml
            openssl
            nodejs
            pnpm
          ];

          # pnpmConfigHook only runs as a build phase; devShells run none.
          shellHook = ''
            bundix -l
            pnpm install
            git add -N .
            runHook postPatch
          '';
        };
      }));
}
