let
  pkgs = import <nixpkgs> { };

in
pkgs.mkShell {
  packages = [
    pkgs.cargo
    pkgs.clippy
    pkgs.railway
    pkgs.rustc
    pkgs.rustfmt
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.libiconv
  ];
}
