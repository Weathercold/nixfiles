{ lib }:

# NUR disallows IFD, which means we can't fetch haumea and then use it during
# evaluation. The solution is to make haumea available as a git submodule prior
# evaluation.
let haumea = { lib = import ./haumea { inherit lib; }; }; in

haumea.lib.load {
  src = ./src;
  inputs = { inherit lib haumea; };
}
