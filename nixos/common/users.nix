{
  pkgs, ...
}:

{
users.users = {
    ducks = {
      isNormalUser = true;
      home = "/home/ducks";
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "input"
        "docker"
        "dialout"  # Framework LED matrix
      ];
      shell = pkgs.nushell;
    };
  };
}
