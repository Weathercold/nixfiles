{ stdenvNoCC, lib, fetchurl }:

let
  version = "2023-07-16-01-25";
  geoipHash = "0p4a8hsfgx8g9pdscmd0wc9j7rl19vadkbakljvrlzncwjyd81aa";
  geositeHash = "0527fprd2xwjwsq41f949hq73gvi5zai2rfr6y6f87ip74gjlmqq";

  repo = "https://github.com/techprober/v2ray-rules-dat";
  geoip = fetchurl {
    url = "${repo}/releases/download/${version}/geoip.dat";
    sha256 = geoipHash;
  };
  geosite = fetchurl {
    url = "${repo}/releases/download/${version}/geosite.dat";
    sha256 = geositeHash;
  };
in

stdenvNoCC.mkDerivation {
  pname = "v2ray-rules-dat";
  inherit version;

  srcs = [ geoip geosite ];

  outputs = [ "out" "geoip" "geosite" ];

  unpackPhase = ''
    mkdir -p source
    cd source
    for src in $srcs; do
      cp $src $(stripHash $src)
    done
  '';

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    install -Dm444 -t "$geoip/share/v2ray" geoip.dat
    install -Dm444 -t "$geosite/share/v2ray" geosite.dat

    runHook postInstall
  '';

  dontFixup = true;

  meta = with lib; {
    description = "Enhanced edition of V2Ray rules dat files (techprober's fork)";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    homepage = repo;
    downloadPage = "${repo}/releases";
    outputsToInstall = [ "geoip" "geosite" ];
    maintainers = with maintainers; [ weathercold ];
  };
}
