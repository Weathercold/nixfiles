{ symlinkJoin, makeWrapper, anki-bin }:
symlinkJoin {
  name = "anki-bin-qt6";
  paths = [ anki-bin ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/anki" --set DISABLE_QT5_COMPAT 1
  '';
}
