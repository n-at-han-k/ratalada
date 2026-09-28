{
  description = "Ruby Project";
  inputs = {
    mine.url = "github:n-at-han-k/flake.nix";
    # follows: without it mine drags in a second nixpkgs closure.
    mine.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, mine, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        lib = mine.lib.${system};
        gems = lib.buildGemset { name = "traefik-forward-auth-bundler-env"; src = ./.; };
      in
      {
        devShells.default = lib.mkRubyShell {
          buildInputs = [ gems gems.wrappedRuby ];
        };
      }
    );
}
