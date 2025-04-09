OUT_TGZ=archlinux.wsl

DLR=curl
DLR_FLAGS=-L
BASE_URL=http://mirrors.edge.kernel.org/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.zst
PAC_PKGS=base base-devel neovim man-db man-pages

all: $(OUT_TGZ)

tgz: $(OUT_TGZ)
$(OUT_TGZ): rootfs.tmp
	@echo -e '\e[1;31mBuilding $(OUT_TGZ)\e[m'
	cd root.x86_64/var/chroot; sudo tar --numeric-owner --absolute-names -c  * | gzip --best > ../../../install.tar.gz
	mv install.tar.gz $(OUT_TGZ)

rootfs.tmp: pacstrap.tmp
	@echo -e '\e[1;31mUmounting proc and sys from bootstrap...\e[m'
	sudo umount root.x86_64/sys
	sudo umount root.x86_64/proc
	-sudo umount root.x86_64/sys
	-sudo umount root.x86_64/proc
	@echo -e '\e[1;31mMaking users in the wheel group access to sudo...\e[m'
	sudo sed -i -e "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" root.x86_64/var/chroot/etc/sudoers
	@echo -e '\e[1;31mCopy WSL config files to rootfs...\e[m'
	sudo cp wsl-distribution.conf root.x86_64/var/chroot/etc/wsl-distribution.conf
	sudo cp wsl.conf root.x86_64/etc/wsl.conf
	sudo mkdir root.x86_64/var/chroot/usr/lib/wsl
	sudo cp oobe.sh root.x86_64/var/chroot/usr/lib/wsl/oobe.sh
	sudo cp archlinux.ico root.x86_64/var/chroot/usr/lib/wsl/archlinux.ico
	sudo cp terminal-profile.json root.x86_64/var/chroot/usr/lib/wsl/terminal-profile.json
	touch rootfs.tmp

pacstrap.tmp: prepare.tmp
	@echo -e '\e[1;31mInstalling basic packages...\e[m'
	sudo chroot root.x86_64 pacman-key --init
	sudo chroot root.x86_64 pacman-key --populate
	sudo chroot root.x86_64 mkdir /var/chroot
	sudo chroot root.x86_64 pacstrap -K /var/chroot $(PAC_PKGS)
	touch pacstrap.tmp

prepare.tmp: bootstrap.tmp
	@echo -e '\e[1;31mGenerating a new mtab file...\e[m'
	sudo rm root.x86_64/etc/mtab
	echo "rootfs / rootfs rw 0 0" | sudo tee root.x86_64/etc/mtab
	@echo -e '\e[1;31mMounting proc to bootstrap...\e[m'
	sudo mount -t proc proc root.x86_64/proc
	@echo -e '\e[1;31mMounting sys to bootstrap...\e[m'
	sudo mount --bind /sys root.x86_64/sys
	@echo -e '\e[1;31mCopying mirrorlist to bootstrap...\e[m'
	sudo cp -f mirrorlist root.x86_64/etc/pacman.d/mirrorlist
	@echo -e '\e[1;31mCopying resolve.conf to bootstrap...\e[m'
	sudo cp -f /etc/resolv.conf root.x86_64/etc/resolv.conf
	touch prepare.tmp

bootstrap.tmp: bootstrap.tar.zst
	@echo -e '\e[1;31mExtracting bootstrap.tar.zst...\e[m'
	sudo tar -xpf bootstrap.tar.zst
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
	-sudo umount root.x86_64/sys
	-sudo umount root.x86_64/proc
	-sudo umount root.x86_64/sys
	-sudo umount root.x86_64/proc
	-rm prepare.tmp

cleantmp:
	-rm *.tmp

cleanbootstrap:
	-rm bootstrap.tar.zst
