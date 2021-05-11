# first set of args is passed by us
{ inputs, lib, ... }@outer_args:
# second set of args is passed by home-manager
{ config, pkgs, ... }: {
  programs.home-manager.enable = true;

  imports = let 
    mkHomeModule = path: (import path outer_args);
  in map mkHomeModule [
    ./home-modules/emacs.nix
    ./home-modules/git.nix
    ./home-modules/fish.nix
  ];

  # direnv & nix-direnv
  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

  home = {
    packages =
      # packages from stable
      with pkgs;
      [
        htop
        ripgrep
        fd
        bat
        python39
        element-desktop # temp stable, until bug resolved
        file
      ] ++
      # packages from unstable
      (with pkgs.unstable; [
        spotify
        discord
        vivaldi
        vivaldi-ffmpeg-codecs
        # element-desktop # known bug: https://github.com/NixOS/nixpkgs/issues/120228
        tdesktop
        keepassxc
        dtrx
        vscode
        zoom-us
        rustup
        cargo-edit
        rust-analyzer
        protonvpn-cli
      ]);

    file = {
      # from https://github.com/NixOS/nixpkgs/issues/107233#issuecomment-757424877
      # -> do this by hand instead, as the file contains a lot of entries by default. (19.4.21)
      # ".config/zoomus.conf".text = ''
      #   enableWaylandShare=true
      # '';
    };

    sessionVariables = {
      EDITOR = "vim";
    };
  };
}
