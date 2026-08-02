{
  lib,
  stdenv,
  fetchFromGitHub,

  godot-mono,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  dotnet-sdk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hydra-text-client";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "SWCreeperKing";
    repo = "HydraTextClient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mVikBCxEHudEBSH6RRdrNuDX7WiU9xj8vRLfwE4nfCk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    godot-mono
    makeWrapper
    copyDesktopItems
    dotnet-sdk
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "hydra-text-client";
      exec = "hydra-text-client";
      icon = "hydra-text-client";
      desktopName = "hydra-text-client";
      comment = "A multi text client for archipelago";
      genericName = "A multi text client for archipelago";
      categories = [ "Game" ];
    })
  ];

  buildPhase = ''
    runHook preBuild

    # Cannot create file `/homeless-shelter/.config/godot/projects/...`
    export HOME=$TMPDIR
    # Link the export-templates to the expected location. The `--export` option expects the templates in the home directory.
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot-mono}/share/godot/templates $HOME/.local/share/godot

    godot-mono --headless --export-pack 'Linux' hydra-text-client.pck

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall


    install -Dm444 hydra-text-client.pck $out/share/hydra-text-client/hydra-text-client.pck

    makeWrapper ${godot-mono}/bin/godot-mono $out/bin/hydra-text-client \
    --add-flag "--main-pack" \
    --add-flag "$out/share/hydra-text-client/hydra-text-client.pck"

    runHook postInstall
  '';


  meta = {
    description = "A multi text client for archipelago";
    homepage = "https://github.com/SWCreeperKing/HydraTextClient";
    changelog = "https://github.com/SWCreeperKing/HydraTextClient/blob/${finalAttrs.src.rev}/Changelog.md";
    license = with lib.licenses; [
      ofl
      mit
    ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "hydra-text-client";
    platforms = lib.platforms.all;
  };
})
