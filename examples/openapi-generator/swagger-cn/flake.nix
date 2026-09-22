{
  description = "Swagger UI, as a Ratalada app";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }:
    (utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        gems = pkgs.bundlerEnv {
          name = "swagger";
          ruby = pkgs.ruby_3_4;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
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

            # The page is a vite build of the fork under frontend/;
            # `overmind` runs the two processes in Procfile.dev.
            nodejs
            pnpm
            overmind
          ];

          shellHook = /* bash */ ''
            export BUNDLE_FORCE_RUBY_PLATFORM=true

            # ratalada is the repository here, not a gem in this bundle.
            # Find the tree rather than count directories; without one,
            # ratalada is a real gem and the bundle has it.
            root="$PWD"
            while [ "$root" != "/" ] && [ ! -f "$root/lib/ratalada.rb" ]; do
              root="$(dirname "$root")"
            done
            if [ -f "$root/lib/ratalada.rb" ]; then
              export RUBYLIB="$root/lib''${RUBYLIB:+:$RUBYLIB}"
            fi

            # ponytail: `pnpm install` hits the registry, so this shell is not
            # offline-reproducible the way the gems are. Pin it like the other
            # examples -- `pkgs.fetchPnpmDeps` + `pnpmConfigHook` -- once
            # pnpm-lock.yaml is committed.
            [ -f package.json ] && pnpm install
          '';
        };
      }));
}
