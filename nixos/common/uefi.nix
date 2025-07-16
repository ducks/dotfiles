{ ... }:
{
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    efiInstallAsRemovable = false;
    devices = [ "nodev" ];
  };
}
