{
  inputs = {
    nixpkgs.url       = github:NixOS/nixpkgs/nixos-unstable;
    home-manager.url  = github:nix-community/home-manager;
    nvim-nightly.url  = github:nix-community/neovim-nightly-overlay;
    spacelix.url      = github:felix-lipski/spacelix;
    auto-bg.url       = github:felix-lipski/auto-bg;
  };

  outputs = { nixpkgs, self, ... }@inputs: 
    {
      nixosConfigurations = let
        overlays = [ inputs.nvim-nightly.overlay ];
        base = host: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
	        { nixpkgs.overlays = overlays; }
            (import (./. + "/machines/${host}.nix"))
            (import ./config.nix)
            inputs.home-manager.nixosModules.home-manager
            inputs.spacelix.spacelix-module
          ];
        };
      in {
        tp  = base "tp";
        dt  = base "dt";
      };
  
    tp  = self.nixosConfigurations.tp.config.system.build.toplevel;
    dt  = self.nixosConfigurations.dt.config.system.build.toplevel;
  };
}
