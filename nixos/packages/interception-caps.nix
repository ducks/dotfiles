{ config, pkgs, ...}:

let
  intercept = "${pkgs.interception-tools}/bin/intercept";
  uinput = "${pkgs.interception-tools}/bin/uinput";
  dual = "${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys";
in {
  environment.systemPackages = with pkgs; [
    interception-tools
    interception-tools-plugins.dual-function-keys
    wev
  ];

  environment.etc."interception/caps-escape.yaml".text = ''
  - JOB: "${intercept} -g $DEVNODE | ${dual} -c /etc/interception/dual-function-keys.yaml | ${uinput} -d $DEVNODE"
    DEVICE:
      EVENTS:
        EV_KEY: [KEY_CAPSLOCK, KEY_LEFTCTRL]
  '';

  environment.etc."interception/dual-function-keys.yaml".text = ''
  TIMING:
    TAP_MILLIS: 200
    DOUBLE_TAP_MILLIS: 0

  MAPPINGS:
    - KEY: KEY_CAPSLOCK
      TAP: KEY_ESC
      HOLD: KEY_LEFTCTRL
  '';

  systemd.services.udevmon = {
    description = "Interception udevmon for dual-function Capslock key";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/test -f /etc/interception/dual-function-keys.yaml";
      ExecStart = "${pkgs.interception-tools}/bin/udevmon -c /etc/interception/caps-escape.yaml";
      Restart = "always";

      CapabilityBoundingSet = [ "CAP_SYS_ADMIN" ];
      AmbientCapabilities = [ "CAP_SYS_ADMIN" ];
      DeviceAllow = [ "/dev/uinput" "rw" "/dev/input/*" "r"];
      PrivateTmp = false;
      ProtectSystem = "full";
    };
  };
}
