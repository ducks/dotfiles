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

  services.kolide-launcher = {
    enable = true;
    kolideHostname = "k2.kolide.com";
    updateChannel = "nightly";
  };
}

