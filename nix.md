---
title: Intro to Nix
sub_title: A **functional** package manager
author: Oskari Tuormaa
theme:
    name: catppuccin-mocha
---

Table of contents
===

1. What is Nix?
2. How does Nix work?

<!-- end_slide -->

What is Nix?
===

<!-- column_layout: [2,1] -->

<!-- column: 1 -->
![](./figs/eelco.jpg)

<!-- column: 0 -->
* Invented in 2003 by Eelco Dolstra in his PhD thesis:
  *The Purely Functional Software Deployment Model*
<!-- pause -->
<!-- newline -->
* A package manager based on the functional programming paradigm
    * No side effects: Purely input-output
    * Immutability
<!-- pause -->
<!-- newline -->
* Key advantages:
    * Declarative over imperative
    * Atomic upgrades
    * Rollbacks
    * Reproducability

<!-- end_slide -->

How does Nix work?
===

All packages live in read-only directory /nix/store:

```bash +no_background
/nix/store/<hash>-<pkgname>-<version>/
```

<!-- pause -->

Hash depends on both package contents and dependencies.

<!-- pause -->

Store can contain any file/directory

```bash +no_background
/nix/store/<hash>-data.zip
/nix/store/<hash>-my_wallpaper.png
/nix/store/<hash>-my_zsh_config/
```

<!-- end_slide -->

How does Nix work?
===

<!-- column_layout: [1,1] -->
<!-- column: 0 -->

```nix +line_numbers {all|4|1|11|6-9|13-21|all}
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
```

<!-- column: 1 -->
<!-- pause -->

Official derivations are hosted at: https://github.com/nixos/nixpkgs

<!-- pause -->
Binary cache hosted at:
https://cache.nixos.org/\<hash\>.narinfo

<!-- pause -->
<!-- newlines: 2 -->

*Package not cached:*
```bash +exec_replace +no_background
echo "
[Evaluate and build\nall dependencies] ->
[Build package]
" | graph-easy --as=boxart
```

<!-- pause -->
<!-- newlines: 2 -->

*Package cached:*
```bash +exec_replace +no_background
echo "
[Evaluate and build\nruntime dependencies] ->
[Download binary]
" | graph-easy --as=boxart
```


<!-- end_slide -->

How does Nix work?
===

Derivations describe the
<!-- pause -->
1. *sources*,
<!-- pause -->
2. *run-/buildtime dependencies*,
<!-- pause -->
3. and *build steps*

needed to build a specific piece of software.

<!-- pause -->
<!-- newlines: 2 -->

**However**:
<!-- pause -->
*The specific nixpkgs version (and thereby dependencies) is unpinned, ie. unpure/imperative!*

<!-- pause -->
<!-- newlines: 2 -->

**The solution**:
<!-- pause -->
<!-- font_size: 2 -->

```bash +no_background +exec_replace
echo Flakes | figlet -tf roman
```

<!-- end_slide -->

Nix Flakes
===


