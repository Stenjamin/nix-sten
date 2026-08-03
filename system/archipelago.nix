{ config, pkgs, system, /*bizhawk-src, fetchpatch,*/ ... }:

let
  bizhawk = pkgs.fetchFromGitHub {
   owner = "TASEmulators";
   repo  = "BizHawk";
   rev   = "master";
   hash  = "sha256-spgoAP1FIBn98DKAWUCnX2MOVKT1yrFH993pF3erf5o=";
  };
  emuhawk = (import bizhawk {inherit system; inherit pkgs; }).emuhawk-2_11_1-bin;
in

{

  # USB2SNES udev rule
  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="5a22", MODE="0666"
  '';

  nixpkgs.overlays = [
    (final: prev: {
      # archipelago = pkgs.callPackage ./archipelago/package.nix {};
      archipelago = prev.archipelago.overrideAttrs (old: {
        version = "0.6.7";
        src = prev.fetchurl {
          url = "https://github.com/ArchipelagoMW/Archipelago/releases/download/0.6.7/Archipelago_0.6.7_linux-x86_64.AppImage";
          hash = "sha256-a5UazzqGu7q4Zg1AYHnbQjCTQNdcNaL/gZUjYV3Rk5Q=";
        };
      });
    })
    (final: prev: {
      qusb2snes = pkgs.callPackage ./qusb2snes/package.nix {};
    })
    (final: prev: {
      sni = pkgs.callPackage ./sni/package.nix {};
    })
    (final: prev: {
      hydratextclient = pkgs.callPackage ./hydratextclient/package.nix {};
    })
    /*(final: prev: {
      bizhawk = pkgs.callPackage "${bizhawk-src}/default.nix" {};
    })*/

  ];

  environment.systemPackages = with pkgs; [
    archipelago
    qusb2snes
    poptracker
    # sni
    # hydratextclient
    # lua5_4
    # bizhawk.emuhawk-2_9_1-bin
    emuhawk
  ];
}
