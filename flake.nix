{
  inputs = {
    unstable.url = github:NixOS/nixpkgs;
    nixpkgs.url = github:NixOS/nixpkgs;
    nixos.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    nix-doom-emacs.url = github:vlaci/nix-doom-emacs;
    emacs-overlay.url = github:nix-community/emacs-overlay;
    neovim-nightly-overlay.url = github:nix-community/neovim-nightly-overlay;
    spacelix.url = github:felix-lipski/spacelix;
    auto-bg.url = github:felix-lipski/auto-bg;
    nix-boiler.url = github:felix-lipski/nix-boiler;
    futhark-vim = {
      url = github:BeneCollyridam/futhark-vim;
      flake = false;
    };
    nixos-godot = {
      url = github:sgillespie/nixos-godot-bin;
      flake = false;
    };
  };

  outputs = { nixpkgs, nix, self, nixos, nix-doom-emacs, ... }@inputs: 
    {
      nixosConfigurations = let
        overlays = [ 
          inputs.neovim-nightly-overlay.overlay 
          (import "${inputs.nixos-godot}/overlay.nix")
        ];
        base = {
          system = "x86_64-linux";
          modules = [
	    { nixpkgs.overlays = overlays; }
            (import ./config.nix)
            inputs.home-manager.nixosModules.home-manager
            inputs.spacelix.spacelix-module
            # (import /home/felix/code/nix/spacelix/spacelix-module.nix)
          ];
        };
      in {
        tp = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = base.modules ++ [ 
            (import ./hosts/tp.nix)
          ];
          specialArgs = { inherit inputs; };
        };
        dt = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = base.modules ++ [ 
            (import ./hosts/dt.nix)
          ];
          specialArgs = { inherit inputs; };
        };
        p17 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = base.modules ++ [ 
            ((import ./hosts/p17.nix) inputs)
          ];
          specialArgs = { inherit inputs; };
        };
      };
  
    tp = self.nixosConfigurations.tp.config.system.build.toplevel;
    dt = self.nixosConfigurations.dt.config.system.build.toplevel;
    p17 = self.nixosConfigurations.p17.config.system.build.toplevel;
  };
}
