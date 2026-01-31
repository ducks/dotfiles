{ config, pkgs, ... }:

let
  nix-agent-flake = builtins.fetchTarball {
    url = "https://github.com/kolide/nix-agent/archive/refs/heads/main.tar.gz";
    sha256 = "0jda5ic2pbb852aj5pqq4a8c06qbgqm1mhdam1w3h0jvljyjjihp";
  };
in
{
  imports = [
    "${nix-agent-flake}/modules/kolide-launcher"
  ];

  # Note: Use k2device.kolide.com, NOT app.kolide.com
  # The launcher only recognizes k2device.kolide.com for enabling the control
  # service and desktop runner (needed for browser-based enrollment)
  services.kolide-launcher = {
    enable = true;
    kolideHostname = "k2device.kolide.com";
    updateChannel = "nightly";
  };
}
