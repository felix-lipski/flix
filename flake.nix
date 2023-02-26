{
  inputs = {
    nixpkgs.url       = github:NixOS/nixpkgs/nixos-unstable;
    nixpkgs-new.url       = github:NixOS/nixpkgs/nixos-unstable;
    home-manager.url  = github:nix-community/home-manager;
    home-manager-new.url  = github:nix-community/home-manager/release-22.05;
    nvim-nightly.url  = github:nix-community/neovim-nightly-overlay;
    nvim-nightly-new.url  = github:nix-community/neovim-nightly-overlay;
    spacelix.url      = github:felix-lipski/spacelix;
    auto-bg.url       = github:felix-lipski/auto-bg;
  };

  outputs = { self, ... }@inputs: 
    {
      nixosConfigurations = let
        oldOverlay = final: prev: {
          old = import inputs.nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        overlays = [ 
          oldOverlay
          # inputs.nvim-nightly-new.overlay
        ];
        base = host: inputs.nixpkgs-new.lib.nixosSystem {
        # base = host: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
	        { nixpkgs.overlays = overlays; }
            (import (./. + "/machines/${host}.nix"))
            (import ./config.nix)
            inputs.home-manager-new.nixosModules.home-manager
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
