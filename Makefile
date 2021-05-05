switch:
	sudo nixos-rebuild switch --impure --flake "./#flix"
pure:
	sudo nixos-rebuild switch --flake "./#flix"
trace:
	sudo nixos-rebuild switch --impure --flake "./#flix" --show-trace
