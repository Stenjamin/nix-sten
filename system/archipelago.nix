{ config, pkgs, ... }:

{

  # USB2SNES udev rule
  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="5a22", MODE="0666"
  '';

  environment.systemPackages = with pkgs; [
    archipelago
    qusb2snes
    poptracker
  ];


}
