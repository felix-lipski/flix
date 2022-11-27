" prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
let g:prettier#config#semi = 'false'
let g:prettier#config#single_quote = 'true'

" leaders
let mapleader = "\<space>"
let maplocalleader = "\<space>"

" fast commands
nnoremap <F4> :w \| make! scf4 <CR>
nnoremap <F5> :w \| make! scf5 <CR>
nnoremap <F6> :w \| make! scf6 <CR>
nnoremap <F7> :w \| make! scf7 <CR>
nnoremap <F8> :w \| make! scf8 <CR>
nnoremap <F9> :w \| make! clean <CR>

nmap <F11> :Prettier <CR>
nnoremap <F12> :w <CR>


" tabbing
set tabstop=4
set shiftwidth=4
set expandtab

" colorscheme
color xelex

" glsl highlight
autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl

au BufRead,BufNewFile *.nim set filetype=nim

au BufRead,BufNewFile *.carp set filetype=carp

let g:syntastic_carp_checkers = ['carp']

" coc accept on enter
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"" treesitter
"lua <<EOF
"langs = { 
"  "nix", "json", "yaml", "toml",
"  "rust", "c", "cpp",
"  "typescript", "javascript", "tsx", "python", 
"  "html",
"  "haskell",
"  "rust"
"}
"require'nvim-treesitter.configs'.setup {
"  ensure_installed = langs,
"  highlight = {
"    enable = langs,
"    disable = {},
"  },
"}
"EOF

