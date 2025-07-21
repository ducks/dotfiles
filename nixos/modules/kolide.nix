{ config, pkgs, ... }:

let
  nix-agent-flake = builtins.fetchTarball {
    url = "https://github.com/kolide/nix-agent/archive/refs/heads/main.tar.gz";
    sha256 = "<FILL_ME_IN>";
  };
in
{
  imports = [
    "${nix-agent-flake}/nixos"
  ];

  services.nix-agent = {
    enable = true;
    enrollSecretPath = "/etc/kolide/secret";
    kolideHostname = "your-team.kolide.com";
  };
}

