{ ... }:

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

}
