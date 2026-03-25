call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'sainnhe/everforest'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'sainnhe/edge'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdcommenter'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'preservim/tagbar'
Plug 'voldikss/vim-floaterm'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'
call plug#end()

let mapleader = "/"

set termguicolors
set background=light
" let g:edge_style = 'light'
" let g:airline_theme = 'edge'
" colorscheme edge
let ayucolor = 'light'
colorscheme ayu

set wildmode=longest,list,full
set wildmenu

let g:airline_powerline_fonts = 1

set nocompatible
set number relativenumber
set laststatus=2
set t_Co=256

set autoread

filetype plugin indent on

" CoC: single LSP
let g:coc_global_extensions = [
      \ 'coc-clangd',
      \ 'coc-tsserver',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-eslint',
      \ 'coc-prettier',
      \ 'coc-pyright'
      \ ]

" ALE: formatting only
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0
let g:ale_set_highlights = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0
let g:ale_fix_on_save = 1
let g:ale_list_window_size = 6

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black'],
\}

let g:ale_python_pycodestyle_options = '--ignore=E501'
let g:ale_python_pylint_options = '--disable=too-few-public-methods'

" GitGutter
let g:gitgutter_sign_added    = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed  = '_'

" Tagbar
let g:tagbar_width    = 40
let g:tagbar_position = 'right'
let g:tagbar_ctags_bin = '/opt/homebrew/bin/ctags'
let g:tagbar_autoclose = 0
let g:tagbar_autofocus = 1

" Python
let g:python3_host_prog = '/opt/homebrew/opt/python@3.13/libexec/bin/python'

" FZF
let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']
let g:fzf_vim.buffers_options = ['--style', 'full', '--border-label', ' Open Buffers ']

" Floaterm
let g:floaterm_wintype = "float"
let g:floaterm_position = "bottomright"
let g:floaterm_width = 0.40
let g:floaterm_height = 0.40
let g:floaterm_autoclose = 0

" Persistent undo
if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undo//
endif

" Keymaps
nnoremap X xi
nnoremap I i<Right>
nnoremap H ^
imap jj <Esc>
nmap Q :b#<CR>
nmap gt :bnext<CR>
nmap gT :bprev<CR>
imap <C-BS> <C-W>
nnoremap :V V`]
nnoremap <leader>w <C-w>w
vmap <Tab> >gv

nnoremap <silent> <C-f> :Rg<CR>
nnoremap <silent> <leader>/ :Lines<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :GFiles<CR>

nnoremap <leader>tt :FloatermToggle<CR>
tnoremap <leader>tt <C-\><C-n>:FloatermToggle<CR>
nnoremap <leader>tk :FloatermKill<CR>

" CoC navigation
nmap gd <Plug>(coc-definition)
nmap gr <Plug>(coc-references)
nmap gi <Plug>(coc-implementation)
nmap K  :call CocActionAsync('doHover')<CR>
nnoremap <leader>rn <Plug>(coc-rename)
nnoremap <leader>d :CocList diagnostics<CR>
nnoremap <leader>s :CocList symbols<CR>

" CoC confirm
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Indentation
set tabstop=4
set shiftwidth=4
set expandtab

autocmd FileType javascript,typescript,typescriptreact,mdx setlocal shiftwidth=2 tabstop=2
autocmd FileType cpp,c setlocal shiftwidth=4 tabstop=4

" Codeforces file template
autocmd BufNewFile *.cc call s:NewCPFile()
function! s:NewCPFile() abort
  let author = 'Artie Humphreys'
  let ts     = strftime('%Y.%m.%d %H:%M:%S')
  call append(0, [
        \ '/**',
        \ ' *    author:  ' . author,
        \ ' *    created: ' . ts,
        \ '**/',
        \ ''])
  execute '4r ' . expand('~/templates/template.cpp')
  normal! 0
endfunction

" clang-format (single source)
augroup clang_format
  autocmd!
  autocmd BufWritePre *.cpp,*.h,*.hpp let cursor_pos = getpos('.') | silent! execute '%!clang-format' | call setpos('.', cursor_pos)
augroup END

command! Cpy execute '%w !pbcopy' | redraw!
