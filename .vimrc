call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'sainnhe/everforest'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'sainnhe/edge'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'prabirshrestha/vim-lsp'
call plug#end()

let g:edge_style = 'aura'
set background=dark
colorscheme edge

set nocompatible              " be iMproved, required
set number relativenumber
set laststatus=2
set t_Co=256
filetype off                  " required

" Enable filetype plugins and indentation
filetype plugin indent on

" Enable ALE completion and settings
let g:ale_completion_enabled = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:ale_open_list = 1
let g:ale_fix_on_save = 1
let b:coc_diagnostic_disable = 1

let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']

" Configure ALE fixers and linters
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'python': ["ruff", "ruff_format"],
\}

let g:ale_linters = {
\   'python': ['pylint', "ruff"],
\}

" Or, for gcc:
let g:ale_cpp_gcc_options = '-std=c++20 -Wno-c++11-extensions'
let g:clang_format#auto_format=1

" Set pylint options to disable specific messages
let g:ale_python_pylint_options = '--disable=too-few-public-methods'

" Autocommands for NERDTree
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
nmap <silent>gr <Plug>(coc-rename)
" CoC (Conquer of Completion) configuration for Python
let g:coc_global_extensions = ['coc-pyright']

" Key mapping to close current buffer
nnoremap X xi
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
nnoremap I i<Right>
inoremap ( ()<Left>
inoremap {<CR>  {<CR>}<Esc>O
imap jj <Esc>
nmap Q :b#<CR>
nmap gt :bnext<CR>
nmap gT :bprev<CR>
imap <C-BS> <C-W>
nnoremap :V V`]
inoremap <S-BS> getline('.') =~ '^\s*$' ? "\<C-o>dd\<C-o>" : "\<BS>"
nnoremap /w <C-w>w
vmap <Tab> >gv
nnoremap <silent> <C-f> :Rg<Space> <CR>

nnoremap <silent> <C-W>w :call SkipQuickfixWindows()<CR>
nnoremap <silent> <C-W>W :call SkipQuickfixWindows()<CR>

set tabstop=4
set expandtab
set shiftwidth=4

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

augroup clang_format
  autocmd!
  autocmd BufWritePre *.cpp,*.h,*.hpp silent! execute '%!clang-format'
augroup END

command! Cpy execute '%w !pbcopy' | redraw!

