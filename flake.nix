{
  inputs = {
    #stable.url = github:NixOS/nixpkgs-channels/20.09;
    unstable.url = github:NixOS/nixpkgs-channels/nixos-unstable;
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    neovim-nightly-overlay.url = github:nix-community/neovim-nightly-overlay;
  };

  outputs = { nixpkgs, nix, self, ... }@inputs: 
    let
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
    in {
      nixosConfigurations.flix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
	  { nixpkgs.overlays = overlays; }
          (import ./configuration.nix)
          inputs.home-manager.nixosModules.home-manager
        ];
        specialArgs = { inherit inputs; };
      };
  
    flix = self.nixosConfigurations.flix.config.system.build.toplevel;
  };
}
