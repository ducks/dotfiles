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
      ];
      shell = pkgs.nushell;
    };
  };
}
