color pablo
lua <<EOF
langs = { "nix", "bash", "json", "css", "c", "cpp", "latex", "ocaml", "python", "typescript" }
require'nvim-treesitter.configs'.setup {
  ensure_installed = langs,
  highlight = {
    enable = langs,
    disable = {},
  },
}
EOF

