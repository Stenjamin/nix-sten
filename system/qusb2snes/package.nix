{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6,
  installShellFiles,
  enableGui ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qusb2snes";
  version = "0.7.36";

  src = fetchFromGitHub {
    owner = "Skarsnik";
    repo = "QUsb2snes";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ZHClCXtlHSU6OJdL2Hi256CLgRzQm6LplXNPxt7dYzo=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
    installShellFiles
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qtwebsockets
    qt6.qtserialport
  ];

  dontUseQmakeConfigure = true;

  buildPhase = ''
    runHook preBuild

    qmake QUsb2snes.pro CONFIG+=release ${lib.optionalString (!enableGui) "QUSB2SNES_NOGUI=1"}
    make -j$NIX_BUILD_CORES

    cd QFile2Snes
    qmake QFile2Snes.pro CONFIG+=release
    make -j$NIX_BUILD_CORES
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ls -la

    installBin QUsb2Snes
    installManPage --name QUsb2Snes.1 QUsb2Snes.manpage.1
    install -Dm644 ui/icons/cheer128x128.png $out/share/icons/hicolor/128x128/apps/fr.nyo.QUsb2Snes.png
    install -Dm644 QUsb2Snes.desktop $out/share/applications/fr.nyo.QUsb2Snes.desktop

    installBin QFile2Snes/QFile2Snes
    installManPage --name QFile2Snes.1 QFile2Snes/QFile2Snes.manpage.1
    install -Dm644 QFile2Snes/icon50x50.png $out/share/icons/hicolor/50x50/apps/fr.nyo.QFile2Snes.png
    install -Dm644 QFile2Snes/QFile2Snes.desktop $out/share/applications/fr.nyo.QFile2Snes.desktop

    runHook postInstall
  '';

  meta = {
    description = "Websocket server that provides a unified protocol for accessing SNES (or SNES emulators) software";
    license = lib.licenses.gpl3Plus;
    homepage = "https://skarsnik.github.io/QUsb2snes/";
    platforms = lib.platforms.linux;
    badPlatforms = lib.platforms.darwin;
    mainProgram = "QUsb2Snes";
    maintainers = with lib.maintainers; [ alexland7219 ];
  };
})
