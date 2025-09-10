OUT_TGZ=archlinux.wsl

DLR=curl
DLR_FLAGS=-L
BASE_URL=http://mirrors.edge.kernel.org/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.zst
PAC_PKGS=base base-devel neovim man-db man-pages

all: $(OUT_TGZ)

tgz: $(OUT_TGZ)
$(OUT_TGZ): rootfs.tmp
	@echo -e '\e[1;31mBuilding $(OUT_TGZ)\e[m'
	cd root.x86_64/var/chroot; sudo tar --numeric-owner --absolute-names -c  * | gzip --best > ../../../$(OUT_TGZ)

rootfs.tmp: pacstrap.tmp
	@echo -e '\e[1;31mMaking users in the wheel group access to sudo...\e[m'
	sudo sed -i -e "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" root.x86_64/var/chroot/etc/sudoers
	@echo -e '\e[1;31mCopy WSL config files and dotfiles to rootfs...\e[m'
	sudo cp etc/*.conf root.x86_64/var/chroot/etc/
	sudo cp -r dotfiles root.x86_64/var/chroot/etc/dotfiles
	sudo cp -r wsl root.x86_64/var/chroot/usr/lib/wsl
	touch rootfs.tmp

pacstrap.tmp: prepare.tmp
	@echo -e '\e[1;31mInstalling basic packages...\e[m'
	sudo chroot root.x86_64 pacman-key --init
	sudo chroot root.x86_64 pacman-key --populate
	sudo chroot root.x86_64 mkdir /var/chroot
	sudo chroot root.x86_64 pacstrap -K /var/chroot $(PAC_PKGS)
	touch pacstrap.tmp

prepare.tmp: bootstrap.tmp
	@echo -e '\e[1;31mBind mounting itself...\e[m'
	sudo mount --bind root.x86_64 root.x86_64
	@echo -e '\e[1;31mCopying resolve.conf to bootstrap...\e[m'
	sudo cp /etc/resolv.conf root.x86_64/etc/resolv.conf
	@echo -e '\e[1;31mCopying mirrorlist to bootstrap...\e[m'
	sudo cp mirrorlist root.x86_64/etc/pacman.d/mirrorlist
	@echo -e '\e[1;31mMounting proc to bootstrap...\e[m'
	sudo mount -t proc /proc root.x86_64/proc
	@echo -e '\e[1;31mMounting sys to bootstrap...\e[m'
	sudo mount --make-rslave --rbind /sys root.x86_64/sys
	@echo -e '\e[1;31mMounting dev to bootstrap...\e[m'
	sudo mount --make-rslave --rbind /dev root.x86_64/dev
	@echo -e '\e[1;31mMounting run to bootstrap...\e[m'
	sudo mount --make-rslave --rbind /run root.x86_64/run
	touch prepare.tmp

bootstrap.tmp: bootstrap.tar.zst
	@echo -e '\e[1;31mExtracting bootstrap.tar.zst...\e[m'
	sudo tar -xpf bootstrap.tar.zst --numeric-owner
	touch bootstrap.tmp

bootstrap.tar.zst:
	@echo -e '\e[1;31mDownloading bootstrap.tar.zst...\e[m'
	$(DLR) $(DLR_FLAGS) $(BASE_URL) -o bootstrap.tar.zst

clean: cleanall

cleanall: cleanrootfs cleanprepare cleantmp cleanbootstrap

cleanrootfs: cleanprepare
	-sudo rm -rf root.x86_64
	-sudo rm pkglist.x86_64.txt
	-rm rootfs.tmp

cleanprepare:
	-sudo umount root.x86_64/proc
	-sudo umount -R root.x86_64/sys
	-sudo umount -R root.x86_64/dev
	-sudo umount -R root.x86_64/run
	-sudo umount root.x86_64
	-rm prepare.tmp

cleantmp:
	-rm *.tmp

cleanbootstrap:
	-rm bootstrap.tar.zst
