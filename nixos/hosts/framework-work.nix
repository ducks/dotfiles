{ ... }:

{
  imports = [
    ../common/base.nix
    ../common/users.nix
    ../common/desktop.nix
    ../common/packages.nix
    ../common/services.nix
    ../common/uefi.nix
  ];

  networking.hostName = "framework-work";
}
