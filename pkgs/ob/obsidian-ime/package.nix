{ obsidian }:
obsidian.overrideAttrs (final: prev: {
  postInstall = ''
    wrapProgram "$out/bin/obsidian" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-wayland-ime}}"
  '';
})
