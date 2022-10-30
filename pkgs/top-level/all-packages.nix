self: super:

let inherit (self) callPackage; in

rec {
  vscode-insiders = callPackage ../applications/editors/vscode/vscode-insiders.nix { };
  vscode-insiders-with-extensions =
    self.vscode-with-extensions.override { vscode = vscode-insiders; };

  vscodium-insiders = callPackage ../applications/editors/vscode/vscodium-insiders.nix { };
}
