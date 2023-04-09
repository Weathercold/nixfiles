# nixfiles

Dotfiles powered by Nix™, plus a package overlay and a library of utility
functions.

## Repository Structure

    nixfiles/
    ├ home/: home configuration
    │ ├ flake/: flake modules
    │ │ └ configurations/: top-level home configurations
    │ │   ├ weathercold/: my configurations
    │ │   ├ custom.nix: a custom example configuration
    │ │   └ default.nix: configuration abstraction
    │ ├ profiles/: top-level home modules
    │ ├ accounts/, programs/, services/, ...: options-based home modules
    │ ├ themes/
    │ │ └ base/, colloid/, ...: home modules for theming; they don't add options and have effect on import
    │ ├ flake-module.nix**
    │ └ flake.nix**
    ├ lib/: library of utility functions
    │ ├ flake-module.nix**
    │ └ flake.nix**
    ├ nixos/: nixos configuration
    │ ├ flake/: flake modules
    │ │ └ configurations/: top-level nixos configurations
    │ │   ├ nixos-inspiron.nix, ...: my configurations
    │ │   └ default.nix: configuration abstraction
    │ ├ profiles/: top-level nixos modules
    │ ├ config/, i18n/, programs/, ...: options-based home modules
    │ ├ hardware/: home modules for hardware; they don't add options and have effect on import
    │ ├ flake-module.nix**
    │ └ flake.nix**
    ├ pkgs/: packaging repository
    │ ├ flake-module.nix**
    │ └ flake.nix**
    └ flake.nix

**flake-module.nix: top-level flake module \
**flake.nix: Each part of this repo (home/, lib/, nixos/, pkgs/) can be used as
flake input by specifying a directory like this
`github:Weathercold/nixfiles?dir=home`

## Import graph

    nixfiles/flake.nix
    ├ home/flake-module.nix
    │ ├ flake/configurations/custom.nix, ...
    │ └ flake/configurations/weathercold/nixos-inspiron.nix
    │   ├ ../default.nix
    │   └ default.nix
    │     └ ../../../profiles/full.nix
    │       ├ base.nix
    │       └ ../accounts/*, ../programs/*, ../services/*, ...
    ├ lib/flake-module.nix
    │ └ default.nix
    │   └ attrsets.nix, filesystem.nix, partials.nix, ...
    ├ nixos/flake-module.nix
    │ └ flake/configurations/nixos-inspiron.nix
    │   ├ default.nix
    │   ├ ../../hardware/inspiron-7405.nix
    │   └ ../../profiles/full.nix
    │     ├ base.nix
    │     │ └ ../config/users.nix
    │     ├ ../hardware/halo65.nix, ...
    │     └ ../config/*, ../i18n/*, ../programs/*, ...
    └ pkgs/flake-module.nix
      └ default.nix
        └ applications/*, data/*, ...
