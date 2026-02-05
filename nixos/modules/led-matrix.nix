{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputmodule-control
  ];

  systemd.services.led-matrix-breathing = {
    description = "Framework 16 LED Matrix Zigzag Breathing";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.inputmodule-control}/bin/inputmodule-control --serial-dev /dev/ttyACM0 led-matrix --stop-game 2>/dev/null; sleep 1; ${pkgs.inputmodule-control}/bin/inputmodule-control --serial-dev /dev/ttyACM0 led-matrix --pattern zigzag --breathing'";
      ExecStop = "${pkgs.inputmodule-control}/bin/inputmodule-control --serial-dev /dev/ttyACM0 led-matrix --pattern all-on --brightness 0";
    };
  };
}
