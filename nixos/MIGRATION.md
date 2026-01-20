# Desktop Migration to NixOS

This guide covers migrating your MSI desktop (ps-ms7a75) from Manjaro to NixOS.

## System Specifications

- **Hostname:** desktop (currently ps-ms7a75)
- **CPU:** Intel Core i7-7700K
- **GPU:** NVIDIA GeForce GTX 1060 6GB
- **Monitor:** 2560x1440@144Hz
- **Current Disk Layout:**
  - `/dev/sda1` - 300M EFI partition
  - `/dev/sda2` - 914G root partition (ext4)
  - `/dev/sda3` - 17.2G swap partition

## Pre-Migration Checklist

- [ ] Backup all important data
- [ ] Export browser profiles and bookmarks
- [ ] Document any custom configurations not in dotfiles
- [ ] Save list of installed packages: `pacman -Qqe > ~/packages.txt`
- [ ] Backup `/etc/fstab` and other system configs if needed

## Installation Steps

### 1. Download NixOS

Download the latest NixOS ISO from https://nixos.org/download

### 2. Boot into NixOS Live Environment

Boot from USB and connect to network:
```bash
sudo systemctl start wpa_supplicant
wpa_cli
# or for wired
sudo systemctl start dhcpcd
```

### 3. Partition Disks (Optional - Skip if Reusing)

If you want to keep your current partitions and data:
- **Skip this step** - your existing partitions will work fine
- Make sure to backup first just in case

If you want a fresh start:
```bash
# Backup first, then:
sudo wipefs -a /dev/sda
sudo gdisk /dev/sda
# Create GPT table, EFI partition (1GB), swap (16-32GB), root (rest)
```

### 4. Format Partitions (Only if Fresh Install)

```bash
# EFI partition
sudo mkfs.fat -F 32 /dev/sda1

# Root partition
sudo mkfs.ext4 -L nixos /dev/sda2

# Swap
sudo mkswap -L swap /dev/sda3
sudo swapon /dev/sda3
```

### 5. Mount Filesystems

```bash
sudo mount /dev/sda2 /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/sda1 /mnt/boot
```

### 6. Generate Initial Configuration

```bash
sudo nixos-generate-config --root /mnt
```

### 7. Clone Your Dotfiles

```bash
sudo mkdir -p /mnt/home/urho
cd /mnt/home/urho
sudo git clone https://github.com/yourusername/dotfiles.git
```

### 8. Use Your Configuration

```bash
# Copy or symlink your desktop configuration
sudo cp /mnt/home/urho/dotfiles/nixos/hosts/desktop.nix /mnt/etc/nixos/configuration.nix

# Or better, use the modular approach:
sudo nano /mnt/etc/nixos/configuration.nix
```

Add to `/mnt/etc/nixos/configuration.nix`:
```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    /home/urho/dotfiles/nixos/hosts/desktop.nix
  ];

  system.stateVersion = "24.11";  # Use current stable version
}
```

### 9. Review Hardware Configuration

```bash
sudo nano /mnt/etc/nixos/hardware-configuration.nix
```

Verify the UUIDs match your system. If you reused partitions, they should match the UUIDs in `desktop.nix`.

### 10. Install NixOS

```bash
sudo nixos-install
```

You'll be prompted to set a root password.

### 11. Set User Password

```bash
sudo nixos-enter
passwd urho
exit
```

### 12. Reboot

```bash
sudo reboot
```

## Post-Installation

### 1. Deploy Dotfiles with Dotter

```bash
cd ~/dotfiles
dotter deploy
```

### 2. Configure Git

```bash
git config --global user.name "Jake Goldsborough"
git config --global user.email "your@email.com"
```

### 3. Install Additional Software

Any additional software not in the NixOS config can be added to:
- `nixos/common/packages.nix` for system-wide packages
- Or use `nix-env -iA nixos.packagename` for user packages
- Or use home-manager (recommended long-term)

### 4. Restore Browser Data

Import your browser profiles and bookmarks.

## Troubleshooting

### NVIDIA Issues

If you have graphics issues:
```bash
# Check driver loaded
lsmod | grep nvidia

# Check Wayland/Hyprland logs
journalctl -b -u display-manager
```

### Boot Issues

If system won't boot:
- Boot into NixOS live USB
- Mount partitions
- `sudo nixos-enter`
- Fix configuration and `sudo nixos-rebuild switch`

### Display Not Working

Add to `desktop.nix` if needed:
```nix
hardware.nvidia.forceFullCompositionPipeline = false;
# or
environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "0";
```

## Notes

- Your current UUIDs are preserved in `desktop.nix`
- NVIDIA proprietary drivers will be installed automatically
- Hyprland configuration from dotfiles will work automatically
- All your Nushell config, Starship, etc. will be available via dotter
- Berkeley Mono font will be installed system-wide

## Rollback Plan

NixOS allows easy rollback:
1. Reboot
2. Select previous generation from boot menu
3. System reverts to previous state

You can also boot back into Manjaro if you keep it on `/dev/sdb` as a backup.
