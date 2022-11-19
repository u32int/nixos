{ inputs, lib, config, pkgs, user, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/suckless
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader.grub = {
      enable = true;
      version = 2;
      # device = "/dev/vda";
      configurationLimit = 4;
      # x230 conf
      efiSupport = true;
      efiInstallAsRemovable = true;
      devices = [ "nodev" ];

      extraEntries = ''
      menuentry "Reboot" {
        reboot 
      }
      menuentry "Halt" {
        halt
      }
      '';
    };
  };

  networking = {
    hostName = "x230";
    networkmanager.enable = true;
    # wireless.enable = true;
    # Open ports in the firewall.
    firewall.enable = true;
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    xserver = {
      enable = true;
      layout = "us";

      displayManager.sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 300 50
      '';

      libinput = {
        enable = true;
	    mouse.accelProfile = "flat";
      };
    };
    # printing.enable = true; 
  };

  # Enable sound.
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  hardware.pulseaudio.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
  };

  environment = {
    systemPackages = with pkgs; [
      neovim
      psmisc
      file
      wget
      zsh
    ];

    variables = {
      EDITOR = "nvim";
    };
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "FiraMono" ]; })
    noto-fonts-emoji
  ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
