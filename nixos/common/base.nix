{ pkgs, ... }:
let
  berkeley-mono = pkgs.callPackage ../modules/berkeley-mono.nix { };
in
{

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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
  networking.networkmanager.wifi.backend = "wpa_supplicant";

  environment.shells = with pkgs; [
    nushell
  ];
}
