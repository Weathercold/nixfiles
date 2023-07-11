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
    x86_64-linux = "119nvg5vrinxxysxxky3g5yrgbz4fbc5pvlq4vcvfdpvb1pp0nhp";
    x86_64-darwin = "1hlkvyifkff21081yrymvjag0i2a9hxacfi8ygj33x9l0lvha3c6";
    aarch64-linux = "1nl1ljzljcmb8lp1wcxqaq0lrjgjw0y3lnvkvipcrfnxlkdrjyci";
    aarch64-darwin = "0nzdyb5fq1q0s6lcilxrdpwn11ma0narv27x71dbnjx7jk0cgfnl";
    armv7l-linux = "1v1xzbzcsdym7k42shqhwnmilridg8aniz71k6911lmvx3f7ncn5";
  }.${system} or throwSystem;
in

callPackage "${path}/pkgs/applications/editors/vscode/generic.nix" rec {
  version = "1.81.0-insider";
  pname = "vscode-insiders";
  updateScript = ./update-vscode-insiders.sh;

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
    homepage = "https://code.visualstudio.com/";
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
