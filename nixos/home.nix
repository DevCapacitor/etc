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
          haskell-vim
          vim-colemak
          vim-surround
          vim-snippets
          vim-fugitive
          vim-javascript
          vim-css-color
          vim-stylish-haskell
          vim-haskell-module-name
          vim-haskellConcealPlus
        ];
        settings = {
          tabstop = 4 ;
          number = true;
          expandtab = true;
          shiftwidth = 4;
        };
        extraConfig = builtins.readFile ./config.vim;
      };
      vscode = {
        enable = true;
        #package = pkgs.vscodium;
        userSettings = {
            "editor.fontFamily" = "Fira Code";
            "editor.fontLigatures" = true;
            "workbench.colorTheme" = "Nord";
            "workbench.startupEditor" = "newUntitledFile";
            "editor.minimap.enabled" = false;
            "workbench.iconTheme" = "vscode-icons";
            "redhat.telemetry.enabled" = true;
            "vsicons.dontShowNewVersionMessage" = true;
            "window.menuBarVisibility" = "toggle";
            "explorer.confirmDelete" = false;
            "files.trimTrailingWhitespace" = true;
          };
      };
  };
  home = {
    username = "aviv";
    homeDirectory = "/home/aviv";
    sessionVariables = {
      TERM = "xterm-256color";
      EDITOR = "nano";
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
    ];
    stateVersion = "21.05";
  };
  manual = {
   html.enable = true;
   json.enable = true;
   manpages.enable = true;
  };
}
