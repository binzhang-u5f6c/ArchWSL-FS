# WSL Root Filesystem Generation for Arch Linux

This is a fork from [yuk7/ArchWSL-FS](https://github.com/yuk7/ArchWSL-FS),
providing a WSL Root FileSystem for Arch Linux.

There are 3 major differences from yuk7's repo:
* use Arch Linux's bootstrap environment to install a filesystem from scratch
  (using `pacstrap`)
* following Microsoft's [tutorial](https://learn.microsoft.com/en-us/windows/wsl/build-custom-distro),
  create WSL configuration files and a Windows Terminal profile
* use `wsl --install --from-file archlinux.wsl` to register wsl

The repo is only to suit my purpose.
Modify `mirrorlist`, `terminal-profile.json`,
and `PAC_PKGS` in `Makefile` to fit your needs.
