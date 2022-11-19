{ lib, inputs, nixpkgs, home-manager, user, ... }:
let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  x230 = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs user; };
    modules = [
      ./x230/configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager = {
          # useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs user; };
          users.${user} = {
            imports = [
                  ./x230/home.nix
            ];
	      };
	    };
      }
    ];
  };
}
