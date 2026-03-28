{
  description = "Sten's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{nixpkgs, home-manager, plasma-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      username = "stephen";
    in {
      homeConfigurations = {
        stephen = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            inputs.plasma-manager.homeModules.plasma-manager
            inputs.steam-config-nix.homeModules.default
            ./home.nix
            {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
            }
          ];
        };
      };
    };
}
