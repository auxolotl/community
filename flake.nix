{
  description = "A project to declaratively add people to GitHub and their related SIG teams";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell { packages = [
	  (pkgs.python3.withPackages (pyPkgs: [ pyPkgs.pydiscourse ]))
	]; };
	formatter = pkgs.nixfmt;
      }
    );
}
