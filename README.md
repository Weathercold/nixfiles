# Abszero

Dotfiles powered by Nix™, plus a package overlay and a library of utility
functions.

I use [haumea](https://github.com/nix-community/haumea):
- to generate lists and trees of modules for `home` and `nixos`;
- as a module system for `lib`.

## Repository Structure

I try to make the repo structure as close to that of nixpkgs as possible,
differing from it only when it makes sense.

Each part of this repo (`home`, `lib`, `nixos`, `pkgs`) has a subflake that can
be used as flake input by specifying a directory like this:
`github:Weathercold/nixfiles?dir=home`

    nixfiles/
    ├ home/                                     home configurations
    │ ├ configurations/                         top-level home configurations
    │ │ ├ weathercold/                          my configurations
    │ │ ├ custom.nix                            a custom example configuration
    │ │ └ _options.nix                          configuration abstraction
    │ └ modules/                                home modules
    │   ├ profiles/                             top-level home modules
    │   ├ accounts/, programs/, services/, ...  options-based home modules
    │   └ themes/                               home modules for theming; they don't add options and have effect on import
    │     └ base/, colloid/, ...
    ├ nixos/                                    nixos configurations
    │ ├ configurations/                         top-level nixos configurations
    │ │ ├ nixos-inspiron7405.nix, ...           my configurations
    │ │ └ _options.nix                          configuration abstraction
    │ ├ profiles/                               top-level nixos modules
    │ ├ config/, i18n/, programs/, ...          options-based home modules
    │ └ hardware/                               nixos modules for hardware; they don't add options and have effect on import
    ├ pkgs/                                     packaging repository
    └ lib/                                      library of utility functions

## Import Graph

    nixfiles/flake.nix
    ├ home/flake-module.nix
    │ ├ configurations/custom.nix, ...
    │ └ configurations/weathercold/nixos-inspiron7405.nix
    │   ├ ../_options.nix
    │   └ _base.nix
    │     └ ../../modules/profiles/full.nix
    │       └ base.nix
    │         └ ../accounts/*, ../programs/*, ../services/*, ...
    ├ lib/default.nix
    │ └ src/*
    ├ nixos/flake-module.nix
    │ └ configurations/nixos-inspiron7405.nix
    │   ├ _options.nix
    │   ├ ../modules/hardware/inspiron-7405.nix
    │   └ ../modules/profiles/full.nix
    │     ├ ../hardware/halo65.nix, ...
    │     └ base.nix
    │       └ ../config/*, ../i18n/*, ../programs/*, ...
    └ pkgs/flake-module.nix
      └ default.nix
        └ applications/*, data/*, ...
