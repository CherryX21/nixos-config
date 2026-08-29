{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  wrapGAppsHook4,
  python3,
  gtk4,
  gtk4-layer-shell,
  util-linux,
  procps,
  coreutils,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      pygobject3
      pycairo
      babel
    ]
  );
in

stdenvNoCC.mkDerivation {
  pname = "mycal";
  version = "unstable-2026-08-24";

  src = fetchFromGitHub {
    owner = "Jamoncillo22";
    repo = "mycal";
    rev = "e0227130dca6b9e45db4b83f5ebb67eb01ae5c1d";
    hash = "sha256-Dy3WiaXz3ihzjnYu8lHmlFEPoo67PP0bh2i7lsHqhgM=";
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mycal
    cp -r . $out/share/mycal/

    mkdir -p $out/bin

    makeWrapper ${pythonEnv}/bin/python3 $out/bin/mycal \
      --add-flags "$out/share/mycal/launcher.py" \
      --prefix PATH : ${
        lib.makeBinPath [
          util-linux
          procps
          coreutils
        ]
      }

    makeWrapper ${pythonEnv}/bin/python3 $out/bin/mycal-bar \
      --add-flags "$out/share/mycal/bar.py"

    makeWrapper ${pythonEnv}/bin/python3 $out/bin/mycal-popup \
      --add-flags "$out/share/mycal/popup.py"

    runHook postInstall
  '';

  meta = {
    description = "Local-first Waybar calendar and reminder popup";
    homepage = "https://github.com/Jamoncillo22/mycal";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "mycal";
  };
}
