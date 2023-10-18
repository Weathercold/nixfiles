{ stdenv
, lib
, path
, callPackage
, fetchurl
, commandLineArgs ? ""
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "082b28vjyi7bq643bdp1m4a6hcf3i16w37kxv95dg38i8abbxnva";
    x86_64-darwin = "1qb436ymbix77aq43swymqdizprfb9k444hfxkpldwfa11yb3wqv";
    aarch64-linux = "05fszk8djf5d1jk2n8s97h484mby14jp3lzlc3j880p0hz3b34d3";
    aarch64-darwin = "0r2xa7vnk0l6n1r090shla5yzrn921fhyks0lh11f9lfl5vn30v2";
    armv7l-linux = "0ac3k816rmy89yq3k6d3cy46yw0ygx33w7fag16phv7jr5h9qhg7";
  }.${system} or throwSystem;
in

callPackage "${path}/pkgs/applications/editors/vscode/generic.nix" rec {
  version = "1.84.0-insider";
  pname = "vscode-insiders";
  updateScript = ./update.sh;

  executableName = "code-insiders";
  longName = "Visual Studio Code - Insiders";
  shortName = "Code - Insiders";
  inherit commandLineArgs;

  src = fetchurl {
    name = "VSCode_${version}_${plat}.${archive_fmt}";
    url = "https://update.code.visualstudio.com/${version}/${plat}/insider";
    inherit sha256;
  };
  sourceRoot = "";

  meta = with lib; {
    description = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS
    '';
    longDescription = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS. It includes support for debugging, embedded Git
      control, syntax highlighting, intelligent code completion, snippets,
      and code refactoring. It is also customizable, so users can change the
      editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://code.visualstudio.com";
    downloadPage = "https://code.visualstudio.com/Updates";
    license = licenses.unfree;
    # !!!: The insiders version breaks frequently, about once every month.
    #      You will get errors such as segfaults, crashes, issues related to
    #      read-only system, etc. For these reasons, I have personally switched
    #      to stable. Please use this package with caution.
    broken = true;
    mainProgram = "code-insiders";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
      "armv7l-linux"
    ];
  };
}
