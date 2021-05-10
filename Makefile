host:
	sudo nixos-rebuild switch --impure --flake .
tp:
	sudo nixos-rebuild switch --impure --flake "./#tp"
switch:
	sudo nixos-rebuild switch --impure --flake "./#vm"
pure:
	sudo nixos-rebuild switch --flake "./#vm"
trace:
	sudo nixos-rebuild switch --impure --flake "./#vm" --show-trace
