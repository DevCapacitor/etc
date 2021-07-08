{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  news.display = "notify";
  programs = {
    home-manager.enable = true;
      git = {
        enable = true;
        userName = "DevCapacitor";
        userEmail = "DevCapacitor@protonmail.com";
      };
      bash = {
        enable = true;
        initExtra = builtins.readFile ./customLook.bash;
        bashrcExtra = builtins.readFile ./config.bash;
        historyFile = "~/.history";
        historyIgnore = [ "ls" "pwd" "cd" "exit" "neofetch" ];
        historyControl = [ "ignoredups" "ignorespace" ];
        shellAliases = {
          ls = "ls --color=auto";
          ll = "ls -l";
          la = "ls -a";
          lal = "ls -al";
          ".." = "cd ..";
        };
      };
      vim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [
          nord-vim
          lightline-vim
          syntastic
          ultisnips
          clang_complete
          a-vim
          autoload_cscope-vim
          vim-colemak
          vim-surround
          vim-snippets
          vim-fugitive
          vim-javascript
          vim-css-color
        ];
        settings = {
          tabstop = 4 ;
          number = true;
          expandtab = true;
          shiftwidth = 4;
        };
        extraConfig = builtins.readFile ./config.vim;
      };
  };
  home = {
    username = "aviv";
    homeDirectory = "/home/aviv";
    sessionVariables = {
      TERM = "xterm-256color";
      EDITOR = "vim";
    };
    packages = with pkgs; [
      # Haskell
      cabal-install
      ghc
      hlint
      stack
      haskell-language-server
      
      # Font
      fira-code
      
      # Archive
      unrar
      unzip
      p7zip
      
      # etc
      git
      tree
      vscode
    ];
    stateVersion = "21.05";
  };
  manual = {
   html.enable = true;
   json.enable = true;
   manpages.enable = true;
  };
}
