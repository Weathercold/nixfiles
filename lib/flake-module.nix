# TODO: Actually use this module
{ inputs, lib, ... }: {
  flake.lib = import ./. {
    inherit lib;
    inherit (inputs) haumea;
  };
}
