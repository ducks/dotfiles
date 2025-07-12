{ config, pkgs, ... }:

{
  imports = [
    ../modules/interception-caps.nix
    ../modules/nixvim.nix
  ];

  programs = {
    hyprland = {
      enable = true;
    };

    light = {
      enable = true;

      brightnessKeys = {
        enable = true;
      };
    };

    starship.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
