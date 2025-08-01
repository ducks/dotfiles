{ pkgs, ... }:

{
  imports = [
    ../common/base.nix
    ../common/users.nix
    ../common/desktop.nix
    ../common/packages.nix
    ../common/services.nix
    ../common/uefi.nix
    ../modules/kolide.nix
  ];

  networking.hostName = "framework-work";

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ducks" ];
  };

  # 1. Enable the system-wide gpg-agent service (systemd socket).
  # This is all that is needed from the module.
  programs.gnupg.agent.enable = true;

  # 2. Make the necessary tools available to all users.
  # The gpg-agent will find 'pinentry-curses' because it's in the PATH.
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-curses
    pass
  ];

  hardware.enableRedistributableFirmware = true;
}
