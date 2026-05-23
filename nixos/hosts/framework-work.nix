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
    ../modules/led-matrix.nix
  ];

  networking.hostName = "framework-work";

  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ducks" ];
  };

  systemd.user.services.lxqt-policykit-agent = {
    description = "LXQt PolicyKit Agent";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart = "on-failure";
    };
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
    gns3-gui
    _1password-cli
    llama-cpp
  ];

  hardware.enableRedistributableFirmware = true;

  # Framework 16 LED Matrix spacers
  services.udev.extraRules = ''
    # Framework Laptop 16 - LED Matrix
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0020", MODE="0660", TAG+="uaccess"
  '';

  services.gns3-server.enable = true;

  # nix-ld: run unpatched dynamically-linked binaries (e.g. the upstream
  # Claude Code binary) without per-shell wrappers. Installs a stub at
  # /lib64/ld-linux-x86-64.so.2 that redirects to the real Nix linker, so
  # /proc/self/exe and argv[0] stay correct — which the wrapper approach
  # in claude-nixos/shell.nix can't preserve.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
    xz
    sqlite
    curl
  ];
}
