{ lib, pkgs, ... }:
{
  users.users.felix = {
    password = "n";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      felix = {
        programs = {
          alacritty = {
            enable = true;
            settings = {
              #font.size = 20;
            };
          };
          zsh = {
            enable = true;
            dotDir = ".config/zsh";
            shellAliases = {
              l = "ls -la";
              v = "nvim";
            };
            localVariables = {
              PROMPT = "%F{blue}%n%f %F{yellow}%~%f ";
            };
            initExtra = "${ lib.fileContents ./dotfiles/zshrc }";
          };
          neovim = {
            enable = true;
            plugins = with pkgs.vimPlugins; [ 
              gruvbox 
            ];
          };
          git = {
            enable = true;
            userEmail = "felix.lipski7@gmail.com";
            userName = "felix-lipski";
          };
        };
      };
    };
  };
}
