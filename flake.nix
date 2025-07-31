{
  inputs = {
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    flake-utils.follows = "cargo2nix/flake-utils";
    nixpkgs.follows = "cargo2nix/nixpkgs";
  };

  outputs = inputs:
    with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [cargo2nix.overlays.default];
          };

          cargo_nix = pkgs.callPackage ./Cargo.nix {};
        in rec {
          packages = {
            asmfmt = cargo_nix.workspaceMembers.asmfmt.build;
            default = packages.asmfmt;
          };
        }
      );
}
