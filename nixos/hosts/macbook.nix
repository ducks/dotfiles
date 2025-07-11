{ ... }:

{
  imports = [
    ../common/users.nix
    ../common/packages.nix
    ../common/services.nix
    ../hardware-configuration.nix
    ../common/misc.nix
    ../common/dev.nix
  ];

  networking.hostName = "macbook";

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
