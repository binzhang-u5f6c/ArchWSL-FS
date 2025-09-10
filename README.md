# WSL Root Filesystem Generation for Arch Linux

This is a fork from [yuk7/ArchWSL-FS](https://github.com/yuk7/ArchWSL-FS),
providing a WSL Root FileSystem for Arch Linux to suit my purpose.

There are two major differences from the origin repo:
* Create a chroot to install the system from scratch
  following ArchWiki's [guide](https://wiki.archlinux.org/title/Install_Arch_Linux_from_existing_Linux#From_a_host_running_another_Linux_distribution).
* Build a custom `.wsl` file with WSL configuration files
  and install via `wsl --install --from-file archlinux.wsl`
  following Microsoft's [tutorial](https://learn.microsoft.com/en-us/windows/wsl/build-custom-distro),
  

**IMPORTANT**: Don't run `make clean` before reboot!!!
When using `--rbind`, some subdirectories of `dev/` are not unmountable.
Running `make clean` before reboot will destroy your `dev/`.

## Post Installation

I record what I would do after installation as follows.

### Install utilities and configure ssh

Select a proper mirror in `/etc/pacman.d/mirrorlist`
and update the system.

```bash
pacman -Syu
```

Then install utilities.

```bash
pacman -S p7zip openssh rsync rclone
```

Generate ssh key and add the public key to Github.

```bash
ssh-keygen -t rsa -b 4096 -C "{email_address}"
```

Add the following to `~/.ssh/config`.

```bash
Host *
    ServerAliveInterval 60
```

### Setup development environment

Put the pre-installed dotfiles at proper positions.

```bash
cat /etc/dotfiles/bashrc > ~/.bashrc
cat /etc/dotfiles/tmux.conf > ~/.tmux.conf
mkdir -p ~/.config/nvim/lua/config
mkdir ~/.config/nvim/lua/plugins
cat /etc/dotfiles/nvim/init.lua > ~/.config/nvim/init.lua
cat /etc/dotfiles/nvim/lua/config/lazy.lua > ~/.config/nvim/lua/config/lazy.lua
cat /etc/dotfiles/nvim/lua/plugins/cmp.lua > ~/.config/nvim/lua/plugins/cmp.lua
cat /etc/dotfiles/nvim/lua/plugins/edit.lua > ~/.config/nvim/lua/plugins/edit.lua
cat /etc/dotfiles/nvim/lua/plugins/lsp.lua > ~/.config/nvim/lua/plugins/lsp.lua
cat /etc/dotfiles/nvim/lua/plugins/ui.lua > ~/.config/nvim/lua/plugins/ui.lua
```

Install utilites for development and configure git.

```bash
pacman -S git ripgrep fzf tmux
git config --global user.name "{name}"
git config --global user.email {email_address}
```

Install uv and Python.

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv python install {python_version}
```

Install Python development tools.

```bash
uv tool install python-lsp-server[flake8,yapf,pydocstyle]
uv tool install jupyterlab
```

Here is an example of create a machine learning project.

```bash
uv init MachineLearning
cd MachineLearning
uv add numpy scipy scikit-learn pandas matplotlib
uv add torch --index pytorch=https://download.pytorch.org/whl/cpu
uv add tensorflow jax
uv add ipykernel
uv run python -m ipykernel install --user --name "{name}" --display-name "{display_name}"
```
