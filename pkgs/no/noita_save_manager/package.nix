{ lib
, python3
, fetchFromGitHub
, makeDesktopItem
, makeWrapper
}:

python3.pkgs.buildPythonApplication rec {
  pname = "noita-save-manager";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mcgillij";
    repo = "noita_save_manager";
    rev = version;
    hash = "sha256-v6zABwYqTCqDRI6uCWyOv8rjBJS2P0BfrOclDkELO/A=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = meta.mainProgram;
    comment = meta.description;
    desktopName = "Noita Save Manager";
    categories = [ "Game" "Utility" ];
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    makeWrapper
  ];

  propagatedBuildInputs = with python3.pkgs; [
    psutil
    pysimplegui
  ];

  postInstall = ''
    # Replace hardcoded path to Noita savegame directory under Proton
    SAVE_MANAGER="$(find "$out" -name save_manager.py)"
    substituteInPlace "$SAVE_MANAGER" \
      --replace '"/home/j/gits/save_noita"' \
                'os.path.expanduser("~") + "/.steam/steam/steamapps/compatdata/881100/pfx/drive_c/users/steamuser/AppData/LocalLow/Nolla_Games_Noita"'

    # Change backup location
    wrapProgram "$out/bin/noita_save_manager" \
      --run 'DIR="''${XDG_DATA_HOME:-~/.local/share}"
             mkdir -p "$DIR/noita_save_manager"
             cd "$DIR/noita_save_manager"'

    mkdir -p "$out/share"
    ln -s ${desktopItem}/share/applications $out/share/applications
  '';

  pythonImportsCheck = [ "noita_save_manager" ];

  meta = with lib; {
    description = "Noita Savegame manager";
    homepage = "https://github.com/mcgillij/noita_save_manager";
    license = licenses.mit;
    maintainers = with maintainers; [ weathercold ];
    mainProgram = "noita_save_manager";
    platforms = platforms.linux;
  };
}
