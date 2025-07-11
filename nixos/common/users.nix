{
  ...
}:

{
users.users = {
    disco = {
      isNormalUser = true;
      home = "/home/disco";
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "input"
        "docker"
      ];
    };
  };
}
