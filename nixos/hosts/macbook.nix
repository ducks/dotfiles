{ ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../common/base.nix
    ../common/users.nix
    ../common/desktop.nix
    ../common/packages.nix
    ../common/services.nix
  ];

  networking.hostName = "{{ hostname }}";

  fileSystems."/" ={
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
