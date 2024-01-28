{ stdenvNoCC, lib, fetchurl }:

let
  version = "2024-01-28-00-58";
  geoipHash = "13bnvzf8zfmx9a32bzv9qnndqbf895bll9rbm0ifzzvjbdcjxir1";
  geositeHash = "1yfi7fnz4rcfa2mf8pflahq38lsyywms8mvhxdi41gkxrb4hqi8w";

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
