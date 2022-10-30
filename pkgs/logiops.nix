{ lib, pkgs, fetchFromGitHub, stdenv, ... }:

stdenv.mkDerivation {
  name = "logiops";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "PixlOne";
    repo = "logiops";
    rev = "8e87b73d7d924006efdb7364d21c34f9ce0115cd";
    sha256 = "sha256-FQaStU/1+89Tc8rK6XL83fBqRr42UKAGOmmCG3Y396I=";
  };

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  buildInputs = with pkgs; [ systemd libevdev libconfig udev ];

  nativeBuildInputs = with pkgs; [ pkg-config cmake ];
}
