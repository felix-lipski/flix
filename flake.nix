{
  inputs = {
    nixpkgs.url       = github:NixOS/nixpkgs;
    unstable.url      = github:NixOS/nixpkgs;
    home-manager      = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "unstable"; };
    nvim-nightly.url  = github:nix-community/neovim-nightly-overlay;
    spacelix.url      = github:felix-lipski/spacelix;
    auto-bg.url       = github:felix-lipski/auto-bg;
  };

  outputs = { nixpkgs, self, ... }@inputs: 
    {
      nixosConfigurations = let
        overlays = [ inputs.nvim-nightly.overlay ];
        unstable = (import inputs.unstable) { config = { allowUnfree = true; }; system = "x86_64-linux"; };
        base = host: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs unstable; };
          modules = [
	        { nixpkgs.overlays = overlays; }
            (import (./. + "/machines/${host}.nix"))
            ((import ./config.nix) unstable)
            inputs.home-manager.nixosModules.home-manager
            inputs.spacelix.spacelix-module
          ];
        };
      in {
        tp  = base "tp";
        dt  = base "dt";
        p17 = base "p17";
      };
  
    tp  = self.nixosConfigurations.tp.config.system.build.toplevel;
    dt  = self.nixosConfigurations.dt.config.system.build.toplevel;
    p17 = self.nixosConfigurations.p17.config.system.build.toplevel;
  };
}
