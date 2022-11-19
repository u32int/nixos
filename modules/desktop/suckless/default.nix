{ inputs, lib, config, pkgs, user, ... }:

{
  nixpkgs = {
    overlays = [
      (final: prev: {
        dwm = prev.dwm.overrideAttrs (old: { src = "${inputs.dotfiles}/.suckless/dwm" ;});
      })
      (final: prev: {
        st = prev.st.overrideAttrs (old: { src = "${inputs.dotfiles}/.suckless/st" ;});
      })
      (final: prev: {
        dmenu = prev.dmenu.overrideAttrs (old: { src = "${inputs.dotfiles}/.suckless/dmenu" ;});
      })
    ];
  };

  services = {
    xserver = {
      windowManager.dwm.enable = true;

      displayManager.lightdm = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    st
    dmenu
  ];
}
