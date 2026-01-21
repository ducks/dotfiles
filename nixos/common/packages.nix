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
    yazi
    kanshi

    # dev packages
    git
    wezterm
    librewolf
    firefox
    dotter
    nushell
    docker
    docker-compose
    fish
    ripgrep
    jq
    glow
    tree
    starship
    tmux
    mdcat
    gh
  ];
}
