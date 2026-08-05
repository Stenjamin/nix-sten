{

  description = "Sten's System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    bizhawk-src = pkgs.fetchFromGitHub {
      owner = "TASEmulators";
      repo  = "BizHawk";
      rev   = "master";
      hash  = "sha256-spgoAP1FIBn98DKAWUCnX2MOVKT1yrFH993pF3erf5o=";
    };
  };

  outputs = { self, nixpkgs, bizhawk-src, ...} :
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        sten-nix = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./archipelago.nix
          ];
          #  specialArgs = { inherit bizhawk-src, system; };
        };
      };
    };

}
