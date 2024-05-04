{ mkShell, python3, ... }:
mkShell {
  packages = [ (python3.withPackages (pyPkgs: [ pyPkgs.pydiscourse ])) ];
}
