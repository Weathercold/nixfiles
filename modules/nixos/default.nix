lib:
rec {
  default = {
    services.rclone = ./services/rclone;
    services.rclone-file-systems = ./services/rclone/file-systems.nix;
  };

  all = lib.recursiveUpdate default {
    hardware.inspiron-7405 = ./hardware/inspiron-7405.nix;
  };
}
