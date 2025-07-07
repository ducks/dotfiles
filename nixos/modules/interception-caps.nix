{ config, pkgs, ...}:

let
  intercept = "${pkgs.interception-tools}/bin/intercept";
  uinput = "${pkgs.interception-tools}/bin/uinput";
  dual = "${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys";
in {
  services.interception-tools = {
    enable = true;
    plugins = with pkgs; [
      interception-tools-plugins.caps2esc
    ];
    udevmonConfig = ''
      - JOB: "${intercept} -g $DEVNODE |
              ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 |
              ${uinput} -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };
}
