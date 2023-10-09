{ lib
, python3
, fetchFromGitHub
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

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    psutil
    pysimplegui
  ];

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
