{
  description = "Takes images and converts them into complex banners.";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlays.default = final: prev: {
        image2banners = prev.pkgs.callPackage ./package.nix {};
      };
    } //
    (flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
        in
          {
            packages.image2banners = pkgs.image2banners;
            packages.default = pkgs.image2banners;
          }
      ));
}
