{
  pkgs,
  ...
}:
{
  imports = [
    /etc/nixos/modules/interception-caps.nix
    /etc/nixos/modules/nixvim.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    git
    librewolf
    wezterm
    clang
    rustup
    nodejs_22
    rust-analyzer
    pamixer
    libreoffice
    hunspell
    hunspellDicts.en_US
    anki-bin
    hyprpaper
    hyprlock
    hypridle
    wofi
    waybar
    dotter
    dunst
    bibata-cursors
    nushell
    docker
    docker-compose
    greetd.tuigreet
    wl-clipboard
  ];

  programs = {
    hyprland = {
      enable = true;
    };

    light = {
      enable = true;

      brightnessKeys = {
        enable = true;
      };
    };

    starship.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
