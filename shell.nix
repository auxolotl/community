{
  mkShellNoCC,
  python3,
  nixfmt-rfc-style,
  ...
}:
mkShellNoCC {
  packages = [
    nixfmt-rfc-style
    (python3.withPackages (pyPkgs: [ pyPkgs.pydiscourse ]))
  ];
}
