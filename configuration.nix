# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  jack.enable = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
};

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelModules = ["snd-seq" "snd-rawmidi" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };



  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w $sys$devpath/brightness"
    '';
  services.unclutter.enable = true ;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
  src = /home/runiales/.local/src/dwm;
  # src = pkgs.fetchgit {
  #   url = "https://github.com/runiales/dwm";
  #   hash = "sha256-et6fUc5T2oknnZQmLR1JkaHoa1c7iCMdy1lwbA1RVQ8=";
  # };
};

services.xserver = {
enable = true;
windowManager.dwm.enable = true;
};

services.xserver.displayManager.startx = {
  enable = true;
  };


  # Configure console keymap
  console.keyMap = "es";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.runiales = {
    isNormalUser = true;
    description = "Cipriano Montes Aranda";
    extraGroups = [ "networkmanager" "wheel" "video" "jackaudio" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

environment.localBinInPath = true;

nixpkgs.overlays = [ (final: prev:
{
dwmblocks = prev.dwmblocks.overrideAttrs (old: {
    # src = /home/runiales/dwmblocks;
    src = prev.fetchgit {
      url = "https://github.com/runiales/dwmblocks";
      hash = "sha256-LJBIX3R0r9A9DwuGxxr6eWtvX0EeGu5mShb58RQt6ZQ=";
      # hash = "sha256-mjAdZCkHCqtkoM4eSDZkL8XX38QRnsPf+jNLB5tMkyY=";
      # url = "https://github.com/lukesmithxyz/dwmblocks";
      # hash = "sha256-gT2PXaQ0VdqlA77jpoXBjuFM5UTuGiIZ5eYzXFVm9TU=";
     };
     });
}
) ];




  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim
  neovim
  dmenu
  firefox
  git
  gnumake
  zsh
  lf
  dwmblocks
  (st.overrideAttrs (oldAttrs: rec {
    src = /home/runiales/.local/src/st;
    # src = fetchgit {
    #   url = "https://github.com/runiales/st";
    #   hash = "sha256-+D6zHYiGG0y0n9BZvN/FT6hGrTQ4PxXNtk8RDA0ZNeA=";
      # };
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
  }))
  fzf
  ueberzugpp
  acpilight
  ardour
  xcompmgr
  libnotify
  dunst
  bc
  calcurse
  exfatprogs
  nsxiv
  xwallpaper
  ffmpeg
  ffmpegthumbnailer
  gnome-keyring
  python313Packages.qdarkstyle
  mdp
  mpc
  mpv
  ncmpcpp
  maim
  unzip
  xcape
  xclip
  xdotool
  yt-dlp
  zathura
  poppler
  mediainfo
  atool
  bat
  file
  odt2txt
  lynx
  slock
  tesseract
  moreutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
};

nix.settings.experimental-features = [ "nix-command" "flakes" ];

users.defaultUserShell = pkgs.zsh;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}

