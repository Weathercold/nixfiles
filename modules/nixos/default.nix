# noauto
lib:

with lib;
with builtins;

let inherit (nixfiles.strings) isEncrypted; in

{
  internal = pipe ./. [
    filesystem.listFilesRecursive
    (filter (hasSuffix ".nix"))
    (filter (f: !isEncrypted (readFile f)))
    # don't import modules with `# noauto` at the start
    (filter (f: !hasPrefix "# noauto" (readFile f)))
  ];

  regular = {
    hardware.inspiron-7405 = ./hardware/inspiron-7405.nix;
  };
}
