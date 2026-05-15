{
  description = "Fablo - Simple tool to generate Hyperledger Fabric network and run it on Docker";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};

      fabloPackage = system: pkgs: pkgs.stdenv.mkDerivation rec {
        pname = "fablo";
        version = "2.6.0";

        src = pkgs.fetchurl {
          url = "https://github.com/hyperledger-labs/fablo/releases/download/${version}/fablo.sh";
          sha256 = "1qnyp55d3kksfwdgla2l07j2slcm9iwyzmwaq0ijbyfpm9cgdqn3";
        };

        dontUnpack = true;

        nativeBuildInputs = [ pkgs.bash ];

        installPhase = ''
          mkdir -p $out/bin
          cp $src $out/bin/fablo
          chmod +x $out/bin/fablo

          # Patch the shebang to use nix's bash
          sed -i '1s|/usr/bin/env bash|${pkgs.bash}/bin/bash|' $out/bin/fablo
        '';

        meta = with pkgs.lib; {
          description = "Simple tool to generate Hyperledger Fabric network and run it on Docker";
          homepage = "https://github.com/hyperledger-labs/fablo";
          license = licenses.asl20;
          platforms = platforms.linux ++ platforms.darwin;
          mainProgram = "fablo";
        };
      };
    in
    {
      packages = forAllSystems (system: let
        pkgs = pkgsFor system;
      in {
        fablo = fabloPackage system pkgs;
        default = self.packages.${system}.fablo;
      });

      apps = forAllSystems (system: let
        pkgs = pkgsFor system;
      in {
        fablo = {
          type = "app";
          program = "${self.packages.${system}.fablo}/bin/fablo";
          meta = {
            description = "Fablo - Hyperledger Fabric network generator";
          };
        };
        default = self.apps.${system}.fablo;
      });
    };
}
