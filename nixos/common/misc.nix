{ pkgs, ... }:
let
  berkeley-mono = pkgs.callPackage ../modules/berkeley-mono.nix { };
in
{
  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  virtualisation.docker.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = [
    berkeley-mono
  ];

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  environment.shells = with pkgs; [
    nushell
  ];
}
