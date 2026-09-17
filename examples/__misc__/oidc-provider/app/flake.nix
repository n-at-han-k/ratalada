{
  description = "OpenCloud Web — Expo Router app";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      forAllSystems = f: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ]
        (system: f nixpkgs.legacyPackages.${system});
    in {
      devShells = forAllSystems (pkgs: {
        # pnpm self-manages to the packageManager version pinned in package.json.
        default = pkgs.mkShell {
          packages = [
            pkgs.nodejs_24
            pkgs.pnpm
          ];

          # @react-native/debugger-shell ships a prebuilt Electron binary ("press j").
          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath (with pkgs; [
              glib nss nspr atk cups dbus libdrm gtk3 pango cairo
              libxkbcommon libgbm alsa-lib expat
              libx11 libxcomposite libxdamage libxext
              libxfixes libxrandr libxcb
            ])}:$LD_LIBRARY_PATH

            if [ ! -d node_modules ]; then
              echo "node_modules not found — running 'pnpm install'..."
              pnpm install
            fi
          '';
        };
      });
    };
}
