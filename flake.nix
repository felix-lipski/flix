{
  inputs = {
    #stable.url = github:NixOS/nixpkgs-channels/20.09;
    unstable.url = github:NixOS/nixpkgs-channels/nixos-unstable;
    nixos.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    neovim-nightly-overlay.url = github:nix-community/neovim-nightly-overlay;
    spacelix.url = github:felix-lipski/spacelix;
  };

  outputs = { nixpkgs, nix, self, nixos, ... }@inputs: 
    {
      nixosConfigurations = let
        overlays = [ inputs.neovim-nightly-overlay.overlay ];
        base = {
          system = "x86_64-linux";
          modules = [
	    { nixpkgs.overlays = overlays; }
            (import ./config.nix)
            inputs.home-manager.nixosModules.home-manager
            inputs.spacelix.spacelix-module
          # (import /home/felix/code/spacelix/spacelix-module.nix)
          ];
        };
      in {
        vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = base.modules ++ [ 
            (import ./vm-config.nix)
            (import ./vm-hardware.nix)
          ];
          specialArgs = { inherit inputs; };
        };
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = base.modules ++ [ 
            (import ./iso-config.nix)
            "${nixos}/nixos/modules/nistaller/cd-dvd/installation=cd-minimal.nix"
          ];
          specialArgs = { inherit inputs; };
        };
        tp = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = base.modules ++ [ 
            (import ./tp-config.nix)
            (import ./tp-hardware.nix)
          ];
          specialArgs = { inherit inputs; };
        };
        
      };
  
    vm = self.nixosConfigurations.vm.config.system.build.toplevel;
    tp = self.nixosConfigurations.tp.config.system.build.toplevel;
    iso = self.nixosConfigurations.iso.config.system.build.isoImage;
  };
}
