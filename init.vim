color pablo
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "nix" },
  highlight = {
    enable = { "nix" },
    disable = {},
  },
}
EOF

