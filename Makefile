switch = sudo nixos-rebuild switch --use-remote-sudo

main: pure

copy-wall:
	cp ~/proj/art/wallpapers/001.png ./home/theme/wallpaper.png

normal: copy-wall
	$(switch) --impure --flake .
pure: copy-wall
	$(switch) --flake .
trace: copy-wall
	$(switch) --impure --flake . --show-trace
edit:
	nvim felix.nix
