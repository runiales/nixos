# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
  src = pkgs.fetchgit {
    url = "https://github.com/runiales/dwm";
    hash = "sha256-Cm54xumHcm4ung5PTsZ97Xv/c+KEic5Onh34M1KjanA=";
  };
};

services.xserver = {
enable = true;
windowManager.dwm.enable = true;
};


  # Configure console keymap
  console.keyMap = "es";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.runiales = {
    isNormalUser = true;
    description = "Cipriano Montes Aranda";
    extraGroups = [ "networkmanager" "wheel" ];
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
  st
  dmenu
  firefox
  git
  gnumake
  zsh
  lf
  dwmblocks
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

  shellAliases = {
    ll = "ls-l";
  };
};

nix.settings.experimental-features = [ "nix-command" ];

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
