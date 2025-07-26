# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let # se utiliza en la config de firefox
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
  in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./boot.nix
    ];

security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  jack.enable = true;
  pulse.enable = true;
};

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  hardware.bluetooth.enable = true; # enables support for Bluetooth

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

services.getty.autologinUser = "runiales";

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
    src = /home/runiales/.local/src/dwmblocks;
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
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
  }))
  nix-search-cli
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
  (ffmpeg.override {
     withXcb = true;
   })
  ffmpegthumbnailer
  gnome-keyring
  python313Packages.qdarkstyle
  mdp
  mpc
  mpv
  xorg.xdpyinfo
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
  coreutils
  moreutils
  networkmanager
  pwvucontrol
  pass
  htop-vim
  tree
  pstree
  wget
  whatsie
  telegram-desktop
  gh
  autorandr
  arandr
  lm_sensors #para temperatura cpu
  transmission_4-qt
  ntfs3g
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    settings = {
      no-allow-external-cache = "";
      allow-preset-passphrase = "";
      max-cache-ttl = 86400;
      };
  };

  security.sudo = {
  enable = true;
  extraRules = [{
    commands = [
      {
        command = "/run/wrappers/bin/umount";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/run/wrappers/bin/mount";
        options = [ "NOPASSWD" ];
      }
    ];
    groups = [ "wheel" ];
  }];
  extraConfig = with pkgs; ''
    Defaults:picloud secure_path="${lib.makeBinPath [
      systemd
    ]}:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  '';
};

programs.virt-manager.enable = true;

users.groups.libvirtd.members = ["runiales"];

virtualisation.libvirtd.enable = true;

virtualisation.spiceUSBRedirection.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

programs.zsh = {
  syntaxHighlighting.enable = true;
  enable = true;
};

  programs.firefox = {
      enable = true;

      /* ---- POLICIES ---- */
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
	EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "default-off";
        SearchBar = "unified";
        NewTabPage = false;

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # vimium
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        /* ---- PREFERENCES ---- */
        # Check about:config for options.
        Preferences = {
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.translations.automaticallyPopup" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        };
	profiles.default = {
          name = "default";
          bookmarks = [
            {
              name = "NixOS Search";
              url = "https://search.nixos.org/packages?query=%s";
              keyword = "nix";
            }
            {
              name = "Nix Options Search";
              url = "https://search.nixos.org/options?query=%s";
              keyword = "nixo";
            }
          ];
        };
      };
    };

   i18n.inputMethod = {
     type = "fcitx5";
     enable = true;
     fcitx5.addons = with pkgs; [
       fcitx5-chinese-addons
     ];
   };

fonts.packages = with pkgs; [
  source-han-sans
  fira-code
  fira-code-symbols
];


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
