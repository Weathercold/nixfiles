{ self, ... }: {
  imports = [ ./_options.nix ];

  nixosConfigurations.nixos-inspiron = {
    system = "x86_64-linux";
    rootPassword = "$6$QOTimFq0v8u6oN.I$.m0BQc/tC6/8nluwwQT7AmkbJbfNoh2PnO9biVL4wgWA22zlb/0HheieexWgISAB67r/7floX3bQpZrUjZv9v.";
    users.weathercold = {
      description = "Weathercold";
    };
    modules = with self.nixosModules; [
      hardware-inspiron-7405
      profiles-full
      { nixfiles.networking.supplicant.enableInsecureSSLCiphers = true; }
    ];
  };
}
