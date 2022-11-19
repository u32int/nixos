{
  description = "vsh's (aka u32int) nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

   # dwm-status = {
   #   url = "github:u32int/dwm-status";
   #   flake = false;
   # }

    dotfiles = {
      url = "github:u32int/dotfiles";
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, dotfiles, ... }:
    let
      user = "vsh";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user dotfiles;
        }
      );
    };
}
