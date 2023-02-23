{
  description = "Federico Izzo personal website built with Hugo";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      {
        flake = { };
        systems = [ "x86_64-linux" "aarch64" ];
        perSystem = { pkgs, lib, ... }:
          let
            shell = pkgs.mkShell {
              buildInputs = with pkgs; [
                go
                hugo
              ];
            };
            blowfish = pkgs.fetchFromGitHub {
              repo = "blowfish";
              owner = "nunocoracao";
              rev = "v2.27.0";
              sha256 = "sha256-dN4wQC0tUynFwXyo0isF9yHPcDAQ9Ec9OH7JeF759nM=";
            };

            fedeizzodev = pkgs.stdenv.mkDerivation {
              name = "fedeizzodev";
              src = ./.;
              buildInputs = with pkgs;[ git go hugo ];
              buildPhase = ''
                mkdir -p themes/blowfish
                cp -r ${blowfish}/* themes/blowfish
                hugo
              '';
              installPhase = ''
                mkdir -p $out
                cp -r * $out/
              '';
            };
          in
          {
            packages.default = fedeizzodev;
            devShells.default = shell;
          };
      };
}


