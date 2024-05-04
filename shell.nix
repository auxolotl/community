{ mkShellNoCC, python3, ... }:
mkShellNoCC { packages = [ (python3.withPackages (pyPkgs: [ pyPkgs.pydiscourse ])) ]; }
