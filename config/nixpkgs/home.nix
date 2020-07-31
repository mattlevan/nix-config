{ config, pkgs, ... }:

with pkgs;
let
  my-pkgs = python-packages: with python-packages; [
    flake8
    pylint
    yapf
  ];
  python-with-my-pkgs = python38.withPackages my-pkgs;
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # My packages.
  home.packages = with pkgs; [
    ctags
    conda
    python-with-my-pkgs
  ];
  
  # My programs.
  programs.bat.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = "
      set nu
    ";
    # extraConfig = builtins.readFile ./home/extraConfig.vim;
    plugins = with pkgs.vimPlugins; [
      ale
      auto-pairs
      coc-nvim
      coc-git
      coc-go
      coc-pairs
      coc-python
      coc-yaml
      fzf-vim
      nerdcommenter
      nerdtree
      vim-airline
      vim-airline-themes
      vim-fugitive
      vim-go
      vim-isort
      vim-nix
      vim-protobuf
      vim-terraform
      vim-yaml
      vista-vim
      semshi
      # youcompleteme
    ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}
