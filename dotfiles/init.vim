nnoremap <F4> :w \| make <CR>
color pablo
lua <<EOF
langs = { 
  "nix", "bash", "json", "yaml", "toml",
  "c", "cpp", "ocaml", "haskell", "rust",
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

