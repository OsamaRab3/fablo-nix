{
  description = "Fablo - Simple tool to generate Hyperledger Fabric network and run it on Docker";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Package configuration - easy to update
      fabloConfig = {
        pname = "fablo";
        version = "2.6.0";
        src = {
          url = "https://github.com/hyperledger-labs/fablo/releases/download/${fabloConfig.version}/fablo.sh";
          sha256 = "1qnyp55d3kksfwdgla2l07j2slcm9iwyzmwaq0ijbyfpm9cgdqn3";
        };
      };
    in
    {
      packages.${system} = {
        fablo = pkgs.stdenv.mkDerivation {
          pname = fabloConfig.pname;
          version = fabloConfig.version;

          src = pkgs.fetchurl {
            url = fabloConfig.src.url;
            sha256 = fabloConfig.src.sha256;
          };

          dontUnpack = true;

          buildInputs = [ pkgs.bash pkgs.docker ];

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
        default = self.packages.${system}.fablo;
      };

      apps.${system} = {
        fablo = {
          type = "app";
          program = "${self.packages.${system}.fablo}/bin/fablo";
          meta = {
            description = "Fablo - Hyperledger Fabric network generator";
          };
        };
        default = self.apps.${system}.fablo;
      };
    };
}
