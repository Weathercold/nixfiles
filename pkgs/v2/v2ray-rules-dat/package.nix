{ stdenvNoCC, lib, fetchurl }:

let
  version = "2023-12-03-00-59";
  geoipHash = "03p54x27ndl50hhfqn2k6hvb7ss3m04wc83iz7q3831jg8rchh93";
  geositeHash = "122l5k96i6n56bra38hlvv6rz0yfrn2x7qiqll76dpq539yskp81";

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
    homepage = repo;
    downloadPage = "${repo}/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ weathercold ];
    outputsToInstall = [ "geoip" "geosite" ];
    platforms = platforms.all;
  };
}
