let

  pkgs = import <nix.pkgs> { };


in
pkgs.callPackage ./package.nix { }
