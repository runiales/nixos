#!/bin/sh

dotfiles="https://github.com/runiales/dotfiles"
dwm="https://github.com/runiales/dwm"
st="https://github.com/runiales/st"
dwmblocks="https://github.com/runiales/dwmblocks"
nixosconfig="https://github.com/runiales/nixos"

putgitrepo(){
	#pone repo $1 en $2
	dir=$(mktemp -d)
	git clone "$1" "$dir"
	ls -la $dir
	[ ! -d "$2" ] && mkdir -p "$2"
	cp -rfT "$dir" "$2" && echo "copiado de $dir a $2"
}

command -v git || ( echo 'Instalando git con "nix-env --install git"' && nix-env --install git )

putgitrepo "$dotfiles" "/home/runiales"
putgitrepo "$st" "/home/runiales/.local/src/st"
putgitrepo "$dwm" "/home/runiales/.local/src/dwm"
putgitrepo "$dwmblocks" "/home/runiales/.local/src/dwmblocks"


putgitrepo "$nixosconfig" "/home/runiales/.config/nixos/"

mkdir /home/runiales/nixbackup
mv /etc/nixos/configuration.nix /home/runiales/nixbackup/configuration.nix
mv -f /etc/nixos/hardware-configuration.nix /home/runiales/.config/nixos/hardware-configuration.nix
ln -s /home/runiales/.config/nixos/configuration.nix /etc/nixos/configuration.nix
ln -s /home/runiales/.config/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix

mkdir /home/runiales/.cache/zsh

chown -R runiales:wheel ~

#TODO:
#Si el equipo tiene LUKS, copiar esa linea a boot.initrd.luks.devices de config
#hacer modular
