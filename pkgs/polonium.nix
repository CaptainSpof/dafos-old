{ lib
, stdenv
, fetchFromGitHub
, libsForQt5
# , kcoreaddons
# , kwindowsystem
# , plasma-framework
# , systemsettings
, cmake
, extra-cmake-modules
, esbuild
}:

stdenv.mkDerivation rec {
  pname = "polonium";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "zeroxoneafour";
    repo = "polonium";
    rev = "04f4450a7ed881dcf9111c04b8000471a7683581";
    sha256 = "sha256-PCgLxh+1lfNKT6v3T0i/lc9Hz3AHyTPnnkaiY9Z74Zs=";
  };

  # cmakeFlags = [
  #   "-DUSE_TSC=OFF"
  #   "-DUSE_NPM=OFF"
  # ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    esbuild
  ];

  buildInputs = with libsForQt5; [
    kcoreaddons
    kwindowsystem
    plasma-framework
    systemsettings
    wrapQtAppsHook
  ];

  configurePhase = "";
  buildPhase = "make build";

  meta = with lib; {
    description = "Tiling window manager for KWin 5.27";
    license = licenses.mit;
    homepage = "https://github.com/zeroxoneafour/polonium";
  };
}
