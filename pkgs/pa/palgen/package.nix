{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "palgen";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "palgen";
    rev = "v${version}";
    hash = "sha256-UU8JoY2EG1/2WHkUkAKGq9CVIYWkQlpp6gIWS45Vdho=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Convert png to palettes in various formats";
    homepage = "https://github.com/xyproto/palgen";
    license = licenses.bsd3;
    maintainers = with maintainers; [ weathercold ];
    platforms = platforms.all;
  };
}
