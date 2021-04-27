all:
	echo "make what?"
switch:
	sudo nixos-rebuild switch --flake "./#flix"
