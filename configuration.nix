# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.nameservers = ["1.1.1.1" "8.8.8.8"];

  # Set your time zone.
  #time.timeZone = "America/Buenos_Aires";
  time.timeZone = "America/Winnipeg";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.

  #environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  #services.dbus.packages = with pkgs; [ dconf ];
  services.displayManager.defaultSession = "none+i3";

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
      wallpaper = {
        mode = "tile";
      };
    };

    displayManager = {
      lightdm = {
        enable = true;
        background = "/home/zach/wallpaper.png";
        greeters = {
          mini = {
            user = "zach";
            enable = true;
            extraConfig = ''
              [greeter]
              show-password-label = false
              show-input-cursor = false
              [greeter-theme]
              font = Sans
              font-size = 1em
              font-weight = bold
              font-style = normal
              text-color = "#ffffff"
              background-color = "#0a1b31"
              window-color = "#27aae1"
              border-color = "#27aae1"
              border-width = 0px
              layout-space = 15
              password-color = "#ffffff"
              password-background-color = "#27aae1"
              password-border-color = "#27aae1"
              password-border-width = 0px
            '';
          };
        };
      };
    };

    windowManager.i3 = {
      enable = true;
      #package = pkgs.i3-gaps;
      configFile = "/etc/i3.conf";
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        xorg.xrandr
        #i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
        polybar
        xss-lock
     ];
    };
  };

  environment.etc."i3.conf".text = import ./i3config.nix;
  environment.etc."i3blocks.conf".text = import ./i3blocks.nix;
  environment.etc."config/polybar" = {
    text = ''
      [bar/example]
      width = 100%
      height = 27
      radius = 6.0
      fixed-center = false
    '';
  };

  # Use PCH for audio (analog should be device 0 in `aplay -l`)
  #environment.etc."asound.conf".text = ''
    #defaults.pcm.!card "PCH"
    #defaults.ctl.!card "PCH"
  #'';

  # Enable the GNOME Desktop Environment.
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # services.layout = "us";
  # services.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable opengl
  hardware.graphics.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zach = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ]; # Enable ‘sudo’ for the user.
  };

  virtualisation = {
    docker = {
      enable = true;
      #autoPrune.enable = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

nixpkgs.config.packageOverrides = pkgs: {
  pidgin-with-plugins = pkgs.pidgin.override {
    plugins = with pkgs; [
      purple-discord
      purple-slack
    ];
  };
};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    iw
    lm_sensors
    wireguard-tools

    git
    htop

    i3-resurrect

    dunst
    libnotify

    pavucontrol

    cifs-utils
  ];

  environment.defaultPackages = with pkgs; [

    teamviewer

    brave
    firefox
    opera
    qutebrowser

    flameshot

    gimp

    sublime-merge
    dbeaver-bin
    mongodb-compass

    prismlauncher

    xfce.thunar
  ];

  environment.extraInit = ''
  alias braveChatGpt="brave https://chatgpt.com"
  export I3CONFIG_DMENU_INCLUDE="firefox brave opera alacritty flameshot mongodb-compass dbeaver ferdium teamviewer qutebrowser thunar braveChatGpt whatsie"
  export I3CONFIG_DEFAULT_TERMINAL="alacritty"
  '';

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    XDG_CURRENT_DESKTOP = "i3";
  };

  programs.light.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  #services.teamviewer.enable = true;

  services.gnome.tracker.enable = true;
  services.gnome.tracker-miners.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Open ports in the firewall.
   #networking.firewall.allowedTCPPorts = [ 43179 7844 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall = {
    allowedUDPPorts = [ 51820 7844 80 443 58012 8180 ]; # Clients and peers can use the same port, see listenport
    allowedTCPPorts = [ 7844 80 443 58012 8180 ];
  };
  # Enable WireGuard
  networking.wg-quick.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      address = [ "10.0.0.3/32" ];
      #listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/zach/.config/wireguard-keys/private";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "SVWl4qGDCBTakNW8IFJ5WQI7ojiryPSLz7BB+o4O50M=";

          # Forward all the traffic via VPN.
          allowedIPs = [ "192.168.50.0/24" ];
          #allowedIPs = [ "0.0.0.0/0" ];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = "24.79.61.66:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576;
    "fs.inotify.max_queued_events" = 524288;
    "fs.file-max" = 300000;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "70000";
  }];

  # Prevent sleep on laptop lid close
  services.logind = {
    lidSwitch = "lock";
    extraConfig = "IdleAction=lock";
  };

  services.tumbler.enable = true; # Thumbnail support for images

  # Prevent nix-direnv cached shells from being gabage-collected
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  # Disable wifi6 due to driver bug, blacklist realtek to fix analog audio
  boot.extraModprobeConfig = ''
    blacklist snd_hda_codec_realtek
  '';
    #options iwlwifi disable_11ax=Y
    #options wlp170s0 disable_11ax=Y

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  programs.ssh.askPassword = "";

  #users.users.cloudflared = {
    #group = "cloudflared";
    #isSystemUser = true;
  #};
  #users.groups.cloudflared = { };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 21d";
  };

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.i3lock}/bin/i3lock -c #0a1b31 -u";
  };

  nix.settings.substituters = [
    "https://nix-community.cachix.org"
  ];

  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  swapDevices = [
    { device = "/dev/disk/by-uuid/dd0c4e40-afa1-4e53-9754-39e50d41c0c5"; }
  ];

}
