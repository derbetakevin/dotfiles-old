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
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Support for Non-LTS kernels
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Disable swraid to get rid of the warning
  boot.swraid.enable = true;

  networking.hostName = "AcerNix2306-1"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
    displayManager = {
      sddm = {
        enable = true;
      };
    };

    desktopManager = {
      plasma5 = {
        enable = true;
      };
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Flatpak support
  services.flatpak.enable = true;

  # Enable fwupd service
  services.fwupd.enable = true;

  # Enable dconf
  programs.dconf.enable = true;

  # QEMU/KVM & Podman
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
	ovmf.enable = true;
      };
    };

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };

  # Environment Variables
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    LIBVIRT_DEFAULT_URI = [ "qemu://system" ];
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
     PasswordAuthentication = true;
    };
  };

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "derbetakevin";
    dataDir = "/home/derbetakevin/Sync";    # Default folder for new synced folders
    configDir = "/home/derbetakevin/.config/syncthing";   # Folder for Syncthing's settings and keys
  };

  # Z-Shell joins the battle!
  programs.zsh.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    derbetakevin = {
      isNormalUser = true;
      description = "Der Beta Kevin";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [
      ];
    };

    jerry = {
      isNormalUser = true;
      description = "Jerry";
      extraGroups = [ "networkmanager" "wheel" ];
      initialPassword = "password";
      packages = with pkgs; [
      ];
    };

    diebetalea = {
      isNormalUser = true;
      description = "Die Beta Lea";
      extraGroups = [ "networkmanager" ];
      initialPassword = "password";
      packages = with pkgs; [
      ];
    };
  };  

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in thr firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    anydesk
    brave
    btop
    clinfo
    cmatrix
    conky
    discord
    distrobox
    eza
    fastfetch
    firefox-wayland
    glxinfo
    google-chrome
    htop
    kate
    kcalc
    libsForQt5.kontact
    libsForQt5.krdc
    microsoft-edge
    neofetch
    neovim
    onlyoffice-bin
    opera
    pciutils
    pfetch
    remmina
    ripgrep
    starship
    syncthing
    spotify
    tdesktop
    teamviewer
    thunderbird
    timeshift
    ubuntu_font_family
    virt-viewer
    virt-manager
    vivaldi
    vivaldi-ffmpeg-codecs
    vlc
    vulkan-tools
    win-virtio
    xdg-user-dirs
    xfce.xfce4-terminal
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
  system.stateVersion = "23.05"; # Did you read the comment?

}
