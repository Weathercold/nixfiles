lib:

with builtins;

let inherit (import ../lib/strings.nix { inherit lib; }) isEncrypted; in

{
  internal = [
    ./services/rclone
  ]
  ++ filter (f: !isEncrypted (readFile f)) [
    ./services/rclone/file-systems.nix
  ];

  regular = {
    hardware.inspiron-7405 = ./hardware/inspiron-7405.nix;
  };
}
