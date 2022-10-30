# noauto
lib:

with lib;
with builtins;

let
  inherit (nixfiles.strings) isEncrypted;
  inherit (nixfiles.filesystem) listDirs listFiles';
in

{
  internal = pipe ./. [
    filesystem.listFilesRecursive
    (filter (hasSuffix ".nix"))
    (filter (f: !isEncrypted (readFile f)))
    # don't import modules with `# noauto` at the start
    (filter (f: !hasPrefix "# noauto" (readFile f)))
  ];

  # Epitome of overengineering
  regular = {
    themes = genAttrs
      (listDirs ./themes)
      (d: pipe d [
        (d: listFiles' ./${d})
        (map (f: nameValuePair (nameFromURL f ".") f))
        listToAttrs
      ]);
  };
}
