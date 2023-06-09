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
    x86_64-darwin = "darwin-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "0dc52n6vj2bbgw1i534i5glzbp757rfmg929ysvv5yhdhkphap3m";
    x86_64-darwin = "0lrbi47jpdn6ddvywy2zxgq5q9z64xdfaxwg7vckf15fzcg4y4v4";
    aarch64-linux = "0k1ms6b94ji6vjjrh7sixvs3j6nz3m7y5lwkh9yxnkwqcqkq9my0";
    aarch64-darwin = "0rgsrpb08niv2zr51kdk5z330fgpz48650z94kwwvjvm4y165lnz";
    armv7l-linux = "1kf8n8prp0d25f0c2031n9iqbvfwin3fzx6qgylprm0pa7h186y2";
  }.${system} or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in

callPackage "${path}/pkgs/applications/editors/vscode/generic.nix" rec {
  version = "1.79.0.23160-insider";
  pname = "vscodium-insiders";
  updateScript = ./update-vscodium-insiders.sh;

  executableName = "codium-insiders";
  longName = "VSCodium - Insiders";
  shortName = "Codium - Insiders";
  inherit commandLineArgs;

  src = fetchurl {
    url = "https://github.com/VSCodium/vscodium-insiders/releases/download"
      + "/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
    inherit sha256;
  };
  inherit sourceRoot;

  # tests = nixosTests.vscodium;

  meta = with lib; {
    description = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS (VS Code without MS branding/telemetry/licensing)
    '';
    longDescription = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS. It includes support for debugging, embedded Git
      control, syntax highlighting, intelligent code completion, snippets,
      and code refactoring. It is also customizable, so users can change the
      editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://github.com/VSCodium/vscodium-insiders";
    downloadPage = "https://github.com/VSCodium/vscodium-insiders/releases";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # !!!: The insiders version breaks frequently, about once every month.
    #      You will get errors such as segfaults, crashes, issues related to
    #      read-only system, etc. For these reasons, I have personally switched
    #      to stable. Please use this package with caution.
    broken = true;
    mainProgram = "codium-insiders";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
    ];
  };
}
