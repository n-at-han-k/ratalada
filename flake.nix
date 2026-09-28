{
  description = "Ruby gem flake";

  inputs = {
    nixpkgs.url = "nixpkgs";
    utils.url = "github:numtide/flake-utils";
    mine.url = "github:n-at-han-k/flake.nix";
    mine.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, mine, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = mine.lib.${system};

        # Not lib.buildGemset: nokogiri needs a gemConfig override, which
        # buildGemset does not take.
        gems = pkgs.bundlerEnv {
          name = "ratalada-gems";
          ruby = pkgs.ruby_3_4;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
          gemConfig = pkgs.defaultGemConfig // {
            nokogiri = attrs: (pkgs.defaultGemConfig.nokogiri attrs) // {
              buildInputs = [ pkgs.rubyPackages_3_4.mini_portile2 ];
            };
          };
        };

      in
      {
        devShells.default = lib.mkRubyShell {
          buildInputs = with pkgs; [
            gems
            gems.wrappedRuby
            trufflehog
          ];

          shellHook = /* bash */ ''
            export BUNDLE_FORCE_RUBY_PLATFORM=true
            export BUNDLE_GEMFILE="$PWD/Gemfile"
            export BUNDLE_FROZEN=false

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
