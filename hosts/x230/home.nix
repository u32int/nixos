{ inputs, lib, config, pkgs, user, ... }:

let
  configpath = ../../config;
in
{
  imports = [
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      # https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";


    packages = with pkgs; [
      home-manager
      # devel
      git
      gcc
      gh

      # utils
      htop
      file

      # apps
      firefox
      pcmanfm
      ranger
      sxiv
      zathura
      mpv
      ffmpeg

      # misc
      neofetch
    ];

    file = {
      ".Xdefaults".source = ../../config/Xdefaults;
      ".zshrc".source = ../../config/zshrc;
    };
  };

  xdg.configFile = {
    "ranger/rc.conf".source = ../../config/ranger/rc.conf;
    "ranger/rifle.conf".source = ../../config/ranger/rifle.conf;
  };

  programs = {
    git = {
      enable = true;
      userName = "vsh";
      userEmail = "88970656+u32int@users.noreply.github.com";
    };

    home-manager = {
      enable = true;
    };
  };

  # Nicely reload system units when changing configs
  # note: this might caues some problems when run from an emergency shell
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
