{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # desktop packages
    libreoffice
    hunspell
    hunspellDicts.en_US
    anki-bin
    hyprpaper
    hyprlock
    hypridle
    wofi
    waybar
    dunst
    bibata-cursors
    pamixer
    greetd.tuigreet
    wl-clipboard

    # dev packages
    git
    wezterm
    librewolf
    dotter
    nushell
    docker
    docker-compose
    fish
  ];
}
