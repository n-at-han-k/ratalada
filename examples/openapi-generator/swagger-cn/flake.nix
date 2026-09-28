{
  description = "Swagger UI, as a Ratalada app";
  inputs = {
    mine.url = "github:n-at-han-k/flake.nix";
    # follows: without it mine drags in a second nixpkgs closure.
    mine.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, mine, nixpkgs, utils }:
    (utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = mine.lib.${system};
        gems = lib.buildGemset { name = "swagger"; src = ./.; };
      in
      {
        # Not lib.mkRubyViteShell: that runs pnpmConfigHook's postPatch, which
        # needs a pnpmDeps hash this example does not have yet.
        devShells.default = lib.mkRubyShell {
          buildInputs = [
            gems
            gems.wrappedRuby

            # The page is a vite build of the fork under frontend/;
            # `overmind` (from mkRubyShell) runs the two Procfile.dev processes.
            pkgs.nodejs
            pkgs.pnpm
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

            [ -f package.json ] && pnpm install
          '';
        };
      }));
}
