let
  fetchInput = input:
    let
      lock = with builtins; (fromJSON (readFile ./flake.lock)).nodes.${input}.locked;
    in
    fetchTarball {
      url = "https://github.com/${lock.owner}/${lock.repo}/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
in

{ lib
, haumea ? { lib = import (fetchInput "haumea") { inherit lib; }; }
}:
haumea.lib.load {
  src = ./src;
  inputs = { inherit lib haumea; };
}
