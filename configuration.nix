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
  time.timeZone = "Europe/Madrid";

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

  #services.dbus.packages = with pkgs; [ gnome3.dconf ];

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
      wallpaper = {
        mode = "tile";
      };
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        background = "#000000";
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
  environment.etc."asound.conf".text = ''
    defaults.pcm.!card "PCH"
    defaults.ctl.!card "PCH"
  '';

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable opengl
  hardware.opengl.enable = true;

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

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    iw
    lm_sensors
  ];

  environment.defaultPackages = with pkgs; [
    alacritty
    discord
    tdesktop
    brave
    i3-resurrect
    kube3d
    git
    bc
    htop
  ];

  environment.extraInit = ''
  export I3CONFIG_DMENU_INCLUDE="firefox brave discord alacritty slack"
  export I3CONFIG_DEFAULT_TERMINAL="alacritty"
  '';

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
  system.stateVersion = "21.05"; # Did you read the comment?

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

}

