color pablo
lua <<EOF
langs = { 
  "nix", "bash", "json", "yaml", 
  "c", "cpp", "ocaml", "haskell", 
  "typescript", "javascript", "tsx", "python", 
  "html", "css", "scss", "latex"
}
require'nvim-treesitter.configs'.setup {
  ensure_installed = langs,
  highlight = {
    enable = langs,
    disable = {},
  },
}
EOF

