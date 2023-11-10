{
  description = "hwaas";

  inputs = {
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs@{ flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        crane = inputs.crane.lib.${system};
      in
      rec {
        packages = {
          default = packages.hwaas;

          hwaas =
            let
              common = {
                src = crane.cleanCargoSource (crane.path ./.);
                strictDeps = true;
                buildInputs = pkgs.lib.optionals pkgs.stdenv.isDarwin [
                  pkgs.libiconv
                ];
              };
              cargoArtifacts = crane.buildDepsOnly common;
            in
            crane.buildPackage (common // { inherit cargoArtifacts; });

          hwaas-image =
            pkgs.dockerTools.buildLayeredImage {
              name = "hwaas";
              config.Entrypoint = [ "${packages.hwaas}/bin/hwaas" ];
            };

          hwaas-stream-image =
            pkgs.dockerTools.streamLayeredImage {
              name = "hwaas";
              config.Entrypoint = [ "${packages.hwaas}/bin/hwaas" ];
            };
        };

        checks = packages // { devShell = devShells.default; };

        devShells.default = crane.devShell {
          inputsFrom = [ packages.hwaas ];
        };
      });
}
