{
  perSystem = { pkgs, ... }: { packages = import ./. { inherit pkgs; }; };
  flake.overlays = rec {
    nixfiles = final: prev: import ./. { pkgs = final; };
    default = nixfiles;
  };
}
