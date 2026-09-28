{
  description = "Ratalada Project";
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
        gems = lib.buildGemset { name = "ratalada"; src = ./.; };
      in
      {
        devShells.default = lib.mkRubyViteShell {
          buildInputs = [ gems gems.wrappedRuby ];

          pnpmDeps = pkgs.fetchPnpmDeps {
            pname = "ratalada";
            version = "0";
            src = ./.;
            fetcherVersion = 4;
            hash = "sha256-DSoaQRCdb9lr/zGPKvHHKPtS9xa2pM+MDAwXWc5P7qk=";
          };
        };
      }));
}
