{

  description = "Sten's System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    bizhawk-src = {
      url = "git+https://github.com/TASEmulators/BizHawk";
      flake = false;
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
          specialArgs = { inherit bizhawk-src;, inherit system; };
        };
      };
    };

}
