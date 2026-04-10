with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "nano-2.3.2";

  src = fetchurl {
    url = ftp://ftp.gnu.org/pub/gnu/nano/nano-2.3.2.tar.gz;
    sha256 = "1s3b21h5p7r8xafw0gahswj16ai6k2vnjhmd15b491hl0x494c7z";
  };

  buildInputs = [ ncurses gettext ];

  # This is actually unnecessary:
  buildCommand =
    ''
      tar xf $src
      cd nano-*
      ./configure --prefix=$out
      make
      make install
    '';
}
