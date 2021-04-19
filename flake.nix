{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs-channels/nixos-unstable;
  };

  outputs = { nixpkgs, nix, self, ... }@inputs: {
    nixosConfigurations.flix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ (import ./configuration.nix) ];
      specialArgs = { inherit inputs; };
    };

    flix = self.nixosConfigurations.flix.config.system.build.toplevel;
  };
}
