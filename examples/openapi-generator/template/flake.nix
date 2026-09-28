{
  description = "OpenAPI document -> Ratalada route tree";
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
        gems = lib.buildGemset { name = "openapi-generator-example"; src = ./.; };

        # The two hooks a template cannot reach: which operations share a file,
        # and what that file is called. javac against the CLI's own jar and an
        # SPI entry -- no Maven, no checkout of the generator.
        expo-codegen = pkgs.stdenv.mkDerivation {
          name = "expo-codegen";
          src = ./generators/expo;

          nativeBuildInputs = [ pkgs.jdk ];

          buildPhase = ''
            mkdir -p classes
            javac -nowarn -proc:none \
              -cp ${pkgs.openapi-generator-cli}/share/java/openapi-generator-cli.jar \
              -d classes $(find src -name '*.java')
            cp -r resources/META-INF classes/
            jar cf expo-codegen.jar -C classes .
          '';

          installPhase = ''
            install -Dm644 expo-codegen.jar $out/share/java/expo-codegen.jar
          '';
        };

        # The packaged CLI runs `java -jar`, which ignores -cp; a generator on
        # the classpath needs the main class named.
        openapi-generator-expo = pkgs.writeShellApplication {
          name = "openapi-generator-expo";
          runtimeInputs = [ pkgs.jre ];
          text = ''
            exec java -cp ${expo-codegen}/share/java/expo-codegen.jar:${pkgs.openapi-generator-cli}/share/java/openapi-generator-cli.jar \
              org.openapitools.codegen.OpenAPIGenerator "$@"
          '';
        };

      in
      {
        packages = { inherit expo-codegen openapi-generator-expo; };

        devShells.default = lib.mkRubyShell {
          buildInputs = [
            gems
            gems.wrappedRuby

            # The patched generator (`-g ratalada-expo`), which writes the
            # route half of every page.
            openapi-generator-expo

            # And upstream's, unpatched, for the CLIENT half
            # (`openapi-generator-cli generate -g ruby`). The npm
            # openapi-generator-cli is the same jar fetched at runtime, which a
            # flake cannot pin, so this is the packaged one instead.
            pkgs.openapi-generator-cli
          ];

          shellHook = /* bash */ ''
            export BUNDLE_FORCE_RUBY_PLATFORM=true

            # ratalada is the repository, not a gem in this bundle. A
            # generated project sits at a different depth from the template
            # it was written out of, so find the tree rather than count
            # directories -- and if there is none, ratalada is a real gem.
            root="$PWD"
            while [ "$root" != "/" ] && [ ! -f "$root/lib/ratalada.rb" ]; do
              root="$(dirname "$root")"
            done
            if [ -f "$root/lib/ratalada.rb" ]; then
              export RUBYLIB="$root/lib''${RUBYLIB:+:$RUBYLIB}"
            fi
          '';
        };
      }));
}
