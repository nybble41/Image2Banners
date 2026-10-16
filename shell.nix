let
  # We pin to a specific nixpkgs commit for reproducibility.
  # Last updated: 2026-10-16. Check for new commits at https://status.nixos.org.
  pkgs = (import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/319e4cebef10cbb636c6ea392137b52ad105336a.tar.gz")) {};
in pkgs.mkShell {
  packages = [
    pkgs.nodejs_latest
    pkgs.electron
    (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
      # select Python packages here
      imageio
      networkx
      numpy
      opencv-python
      packaging
      pillow
      scikit-image
      scipy
      tifffile
    ]))
  ];
}
