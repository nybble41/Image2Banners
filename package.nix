# Inspired by pkgs/applications/editors/uivonim/default.nix 
{ lib, buildNpmPackage, fetchFromGitHub, electron, python3, makeWrapper }:
let

  pythonEnv = python3.withPackages (ps: with ps; [
    imageio
    networkx
    numpy
    opencv-python
    packaging
    pillow
    scikit-image
    scipy
    tifffile
  ]);

  electronDist = electron;

in buildNpmPackage rec {
  pname = "image2banners";
  version = "2.4.0-jdm1";

  src = ./.;

  npmDepsHash = "sha256-hMXlGxd6Wk8+/Dsw1xCkK/L+hNkvtxiHQBQC9g/KiMc=";

  # Useful for debugging, just run "electron ."
  nativeBuildInputs = [
    electronDist
    makeWrapper
  ];

  buildInputs = [
    pythonEnv
  ];

  # Otherwise it will try to run a build phase (via npm build) that we don't have or need, with an error:
  # Missing script: "build"
  # This method is used in pkgs/by-name/in/indiepass-desktop/package.nix
  dontNpmBuild = true;

  # Needed, otherwise you will get an error:
  # RequestError: getaddrinfo EAI_AGAIN github.com
  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  meta.mainProgram = "${pname}";

  # The node_modules/XXX is such that XXX is the "name" in package.json
  # The path might differ, for instance in electron-forge you need build/main/main.js
  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/lib/node_modules/${pname}/main.js \
      --prefix PATH : ${lib.makeBinPath [ pythonEnv ]}
  '';

  preFixup = ''
    substituteInPlace $out/lib/node_modules/${pname}/main.js \
      --replace-fail \'app.py\' \'$out/lib/node_modules/${pname}/app.py\'

    substituteInPlace $out/lib/node_modules/${pname}/utils.py \
      --replace-fail \'assets\' \'$out/lib/node_modules/${pname}/assets\'
  '';

}
