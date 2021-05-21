switch = sudo nixos-rebuild switch

normal:
	$(switch) --impure --flake .
pure:
	$(switch) --flake .
trace:
	$(switch) --impure --flake . --show-trace
edit:
	nvim felix.nix
