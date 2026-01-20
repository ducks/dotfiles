{ config, pkgs, ... }:

{
  imports = [
    ../common/base.nix
    ../common/users.nix
    ../common/desktop.nix
    ../common/packages.nix
    ../common/services.nix
    ../common/uefi.nix
  ];

  networking.hostName = "desktop";

  # NVIDIA GPU configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    grim
    slurp
    nvtopPackages.nvidia
  ];

  # Enable OpenGL for NVIDIA
  hardware.nvidia.forceFullCompositionPipeline = true;

  # Boot configuration - update these UUIDs after NixOS installation
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3a6e1b0d-ff59-48d1-8a1f-870dadc441f5";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9E6B-8B34";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/36dcbcf0-2140-43e9-87cc-6e57be4d598e"; }
  ];

  # CPU-specific optimizations
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

  # High refresh rate monitor support
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
