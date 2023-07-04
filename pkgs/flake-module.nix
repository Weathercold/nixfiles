{
  perSystem = { pkgs, ... }: { packages = import ./. { inherit pkgs; }; };
  flake.overlays = rec {
    abszero = final: prev: import ./. { pkgs = final; };
    default = abszero;
  };
}
