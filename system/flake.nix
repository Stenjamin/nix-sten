{

  description = "Sten's System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ...} :
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
        };
      };
    };

}
