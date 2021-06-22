" prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
let g:prettier#config#semi = 'false'
let g:prettier#config#single_quote = 'true'

" leaders
let mapleader = "\<space>"
let maplocalleader = "\<space>"

" fast commands
nnoremap <F4> :w \| make! <CR>

nnoremap <F12> :w <CR>

nmap <F8> :Prettier <CR>

" tabbing
set tabstop=4
set shiftwidth=4
set expandtab

" colorscheme
color delek

" glsl highlight
autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl

" treesitter
lua <<EOF
langs = { 
  "nix", "bash", "json", "yaml", "toml",
  "c", "cpp", "haskell", "rust",
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

