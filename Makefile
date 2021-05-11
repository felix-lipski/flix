switch = sudo nixso-rebuild switch

normal:
	$(switch) --impure --flake .
pure:
	$(switch) --flake .
trace:
	$(switch) --impure --flake . --show-trace


sswitch:
	sudo nixos-rebuild switch --impure --flake .
ppure:
	sudo nixos-rebuild switch --flake .
ttrace:
	sudo nixos-rebuild switch --impure --flake . --show-trace
