{
  outputs = { self, nixpkgs }:
    let
      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }:
        {
          default = pkgs.stdenv.mkDerivation (with pkgs; {
            pname = "xwaylandvideobridge";
            version = "unstable-2023-05-28";

            src = fetchFromGitLab {
              domain = "invent.kde.org";
              owner = "system";
              repo = "xwaylandvideobridge";
              rev = "850ea0d965426e85746d5e2d4dd6f4c146403b7b";
              hash = "sha256-5gRSkSdp9CGiVWjvIPKXPyEnI6hm1h2IeMunZymNa/M=";
            };

            nativeBuildInputs = [
              cmake
              extra-cmake-modules
              pkg-config
              libsForQt5.qt5.wrapQtAppsHook
            ];

            buildInputs = [
              qt5.qtbase
              qt5.qtquickcontrols2
              qt5.qtx11extras
              libsForQt5.kdelibs4support
              (libsForQt5.kpipewire.overrideAttrs (oldAttrs: {
                version = "unstable-2023-05-23";

                src = fetchFromGitLab {
                  domain = "invent.kde.org";
                  owner = "plasma";
                  repo = "kpipewire";
                  rev = "600505677474a513be4ea8cdc8586f666be7626d";
                  hash = "sha256-ME/9xOyRvvPDiYB1SkJLMk4vtarlIgYdlereBrYTcL4=";
                };
              }))
            ];
          });
        });
    };
}
