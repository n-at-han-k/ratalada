{
  description = "Ruby gem flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        gems = pkgs.bundlerEnv {
          name = "ratalada-gems";
          ruby = pkgs.ruby_3_4;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
        };

      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.pkg-config # native extension discovery
          ];

          buildInputs = with pkgs; [
            bundix
            gems
            gems.wrappedRuby
            libyaml
            openssl
            trufflehog
          ];

          shellHook = /* bash */ ''
            export LANG="''${LANG:-C.UTF-8}"
            export LC_ALL="''${LC_ALL:-$LANG}"

            # None of this repo's gems are in the bundle — they are the
            # repository — so put this lib/ on the load path and let
            # `require "ratalada"` find the working tree.
            export RUBYLIB="$PWD/lib''${RUBYLIB:+:$RUBYLIB}"

            if [ ! -f .git/hooks/pre-commit ]; then
              bundle exec lefthook install
            fi
          '';
        };
      }
    );
}

