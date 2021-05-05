color pablo
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "nix", "bash", "json", "css" },
  highlight = {
    enable = { "nix", "bash", "json", "css" },
    disable = {},
  },
}
EOF

