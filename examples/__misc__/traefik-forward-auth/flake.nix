{
  description = "Ruby Project";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        gems = pkgs.bundlerEnv {
          name = "traefik-forward-auth-bundler-env";
          ruby = pkgs.ruby_3_4;
          gemfile  = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset   = ./gemset.nix;
        };

      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = with pkgs; [
            bundix
            gems
            gems.wrappedRuby
            libyaml
            openssl
          ];
        };
      }
    );
}
