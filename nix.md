---
title: Reproducible Dev Environments
sub_title: with **Nix Flakes**
author: Oskari Tuormaa
theme:
    name: catppuccin-mocha
---

<!-- jump_to_middle -->

The Problem We All Know
===

<!-- end_slide -->

"It works on my machine"
---

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

Sound familiar?

* Colleague checks out the repo
* Spends **half a day** installing the toolchain
* Builds fine locally, **fails on CI**
* 2+ devs, 2+ `arm-none-eabi-gcc` versions → subtle bugs

<!-- column: 1 -->

<!-- pause -->

> [!warning]
> Your dev environment is **mutable, implicit state** — and it lives outside version control

<!-- reset_layout -->

<!-- pause -->

---

What if the environment was just another file in the repo?

<!-- end_slide -->

<!-- jump_to_middle -->

What is Nix?
===

<!-- end_slide -->

Nix: a functional package manager
---

Nix is a package manager that runs on any Linux or macOS system, alongside your existing tools.

<!-- pause -->

**The key idea:**

> Every package is identified by a cryptographic hash of **all its inputs** — source, dependencies, compiler flags, everything.

<!-- pause -->

---

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

**Traditional package manager (`apt`, `brew`)**

* Global mutable state
* Upgrading X can break Y
* No two machines are guaranteed identical

<!-- column: 1 -->

**Nix**

* Packages live in `/nix/store/<hash>-pkg`
* Multiple versions coexist safely
* Identical hash → identical result, always

<!-- reset_layout -->

<!-- end_slide -->

Nix vs Docker
---

Both solve reproducibility — but in very different ways:

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

**Docker**

* Ships a full OS image
* Runs in an isolated container — _separate_ from your host
* Dev workflow: mount source, exec into container
* Requires a daemon + root (or rootless workarounds)
* Image = black box unless you audit the `Dockerfile`

<!-- column: 1 -->

**Nix**

* Ships only the exact packages needed
* Runs directly on your host — _no_ virtualisation layer
* Dev workflow: `nix develop`, then work normally
* No daemon, no root, no container overhead

<!-- reset_layout -->

<!-- end_slide -->

<!-- jump_to_middle -->

Nix Flakes
===

<!-- end_slide -->

Flakes: pinned, shareable environments
---

A **flake** is two files committed to your repo:

| File | Purpose |
| ------------ | ----------------------------------------------- |
| `flake.nix` | Declares inputs (packages, toolchains) and outputs (dev shell) |
| `flake.lock` | Pins every input to an exact revision (automatically generated) |

<!-- pause -->

---

`flake.lock` is like `package-lock.json` or `Cargo.lock` — but for **your entire toolchain**.

Anyone with Nix runs one command and gets an **identical shell**:

```bash
nix develop
```

<!-- end_slide -->

A minimal flake for embedded development
---

```nix +line_numbers
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        gcc-arm-embedded
        cmake
        ninja
        openocd
        gdb
      ];
    };
  };
}
```

<!-- pause -->

Commit this + the generated `flake.lock` → **env is now version-controlled**.

<!-- end_slide -->

<!-- jump_to_middle -->

Live Demo
===

<!-- end_slide -->

Bonus features
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

# **`direnv` integration**

Add a `.envrc`:

```bash
use flake
```

Shell activates **automatically** on `cd` into the project. No manual `nix develop` needed.

<!-- pause -->
<!-- column: 1 -->

# CI/CD: no more "works locally"

Your CI pipeline becomes trivial:

```yaml
- name: Build firmware
  run: nix develop --command make all
```

<!-- pause -->

* Same `flake.lock` as your local machine
* Same compiler, same flags, same sysroot

<!-- pause -->
<!-- reset_layout -->
---

# NixOS: A Nix based OS

A full Linux distro where the **entire OS** is declarative (ie. described in Nix files).

* Bad update? Reboot into the previous generation from the bootloader
* Reproduce any machine from its config in minutes
* Shows how far the reproducibility principle can scale

<!-- end_slide -->

Getting started — three steps
---

**Step 1: Install Nix**

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

<!-- pause -->

**Step 2: Enable flakes** (add to `~/.config/nix/nix.conf`)

```
experimental-features = nix-commands flakes
```

<!-- pause -->

**Step 3: Add a `flake.nix` to project**

<!-- end_slide -->

Resources
---

<!-- alignment: center -->

| Resource | Link |
| -------- | ---- |
| Package search | search.nixos.org |
| Historic Package search | nixhub.io |
| Nix language basics | nix.dev/tutorials |
| Flakes reference | wiki.nixos.org/wiki/Flakes |
| Zero-to-Nix (beginner guide) | zero-to-nix.com |


<!-- end_slide -->

<!-- jump_to_middle -->

Questions?
===
