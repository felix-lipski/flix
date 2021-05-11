{
  inputs = {
  # stable.url = github:NixOS/nixpkgs-channels/20.09;
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
            (import ./hosts/vm-config.nix)
          ];
          specialArgs = { inherit inputs; };
        };
        tp = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = base.modules ++ [ 
            (import ./hosts/tp-config.nix)
          ];
          specialArgs = { inherit inputs; };
        };
      };
  
    vm = self.nixosConfigurations.vm.config.system.build.toplevel;
    tp = self.nixosConfigurations.tp.config.system.build.toplevel;
  };
}
