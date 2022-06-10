set modeline
set modelines=3
" vim: foldmethod=marker
" vim: foldcolumn=3
" vim: foldlevel=0

let g:mapleader = "\<Space>"

if &compatible
  set nocompatible
endif

augroup MyAutoCmd
  autocmd!
augroup END

" ---------------------------------------------------------------------------
"  plugin settings
" ---------------------------------------------------------------------------
filetype plugin indent on
set runtimepath+=$XDG_CACHE_HOME/dein/repos/github.com/Shougo/dein.vim

if dein#load_state(expand('$XDG_CACHE_HOME/dein'))
  " XDG base direcory compartible
  let g:dein#cache_directory = expand('$XDG_CACHE_HOME/dein')
  " toml files
  let s:toml_dir   = expand('$XDG_CONFIG_HOME/nvim/dein/toml')
  let s:toml       = s:toml_dir . '/dein.toml'
  let s:lazy_toml  = s:toml_dir . '/dein_lazy.toml'

  call dein#begin(expand('$XDG_CONFIG_HOME/dein'))

  call dein#load_toml(s:toml,       {'lazy': 0})
  call dein#load_toml(s:lazy_toml,  {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

" ---------------------------------------------------------------------------
"  basic settings
" ---------------------------------------------------------------------------
set printfont=Cica:h12
set ambiwidth=single " https://qiita.com/tomonic-x/items/601343ec3e5f6bd59c0d
syntax enable
autocmd FileType jsp,asp,php,xml,perl syntax sync minlines=500 maxlines=1000
autocmd FileType vue syntax sync fromstart
autocmd FileType json syntax match Comment +\/\/.\+$+ " for jsonc
autocmd BufNewFile,BufRead *.slim setlocal filetype=slim
set termguicolors
" $TERMがxterm以外のときは以下を設定する必要がある。
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " 文字色
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" " 背景色
" let g:hybrid_custom_term_colors = 1
" let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
colorscheme iceberg
set background=dark    "または light
set nonumber
set title
set showcmd
set laststatus=2
set visualbell t_vb=
set ignorecase
set smartcase
set nofixeol " 自動でファイル末尾の改行を加えるのをやめる

" yank したら * レジスタにもコピー
set clipboard+=unnamed

" highway grep
" set grepprg=hw\ --no-group\ --no-color

" git commit で差分確認
" https://qiita.com/soramugi/items/a56b570a80372994000b
autocmd FileType gitcommit DiffGitCached | wincmd x | resize 10

" インデント設定
set tabstop=2
set shiftwidth=2
set softtabstop=2
augroup vimrc
  autocmd! FileType perl    setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd! FileType php     setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd! FileType ruby    setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd! FileType eruby   setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd! FileType html    setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd! FileType css     setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd! FileType elm     setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd! FileType haskell setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd! FileType markdown setlocal shiftwidth=4 tabstop=4 softtabstop=4
augroup END
set autoindent
set smartindent
set expandtab
set smarttab
set shiftround
set nowrap
set hidden
set history=2000
set hlsearch
set incsearch
set ruler
set nocursorline
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<,eol:<
set diffopt=filler,vertical

" ---------------------------------------------------------------------------
" custom keymap
" ---------------------------------------------------------------------------
nnoremap <Space> <Nop>
noremap <C-h> ^
noremap <C-l> $
nnoremap <Leader>/ *<C-o>
nnoremap g<Leader>/ g*<C-o>
"highlight off
nnoremap <silent> <Leader>nh :noh<CR>
" 連続ペースト用
nnoremap <Leader>p "0p<CR>
nnoremap ;  :
nnoremap :  ;
vnoremap ;  :
vnoremap :  ;
nnoremap k   gk
nnoremap j   gj
vnoremap k   gk
vnoremap j   gj
nnoremap gk  k
nnoremap gj  j
vnoremap gk  k
vnoremap gj  j
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q ge
" paste toggle
inoremap <F11> <nop>
set pastetoggle=<F11>
autocmd InsertLeave * set nopaste
" 方向キーなどいらぬ
vnoremap  <Up>     <nop>
vnoremap  <Down>   <nop>
vnoremap  <Left>   <nop>
vnoremap  <Right>  <nop>
inoremap  <Up>     <nop>
inoremap  <Down>   <nop>
inoremap  <Left>   <nop>
inoremap  <Right>  <nop>
noremap   <Up>     <nop>
noremap   <Down>   <nop>
noremap   <Left>   <nop>
noremap   <Right>  <nop>
" terminal 設定
if has('nvim')
  tnoremap <C-o> <C-\><C-n>
  tnoremap <silent> <ESC> <C-\><C-n>
end
" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>
" buffer delete時にウインドウを消さない
noremap <Leader>bd :bp<bar>sp<bar>bn<bar>bd<CR>
" パス補完
cnoremap <C-x> <C-r>=expand('%:p')<CR>

" ---------------------------------------------------------------------------
" パス系
" ---------------------------------------------------------------------------
" 指定のデータをレジスタに登録する
function! s:Clip(data)
  let @*=a:data
  echo "clipped: " . a:data
endfunction

" 現在開いているファイルのパスをレジスタへ
command! -nargs=0 ClipPath call s:Clip(expand('%:p'))
" 現在開いているファイルのファイル名をレジスタへ
command! -nargs=0 ClipFile call s:Clip(expand('%:t'))
" 現在開いているファイルのディレクトリパスをレジスタへ
command! -nargs=0 ClipDir  call s:Clip(expand('%:p:h'))

" ---------------------------------------------------------------------------
" other
" ---------------------------------------------------------------------------
" not stop completion $ & /
setlocal iskeyword+=$
setlocal iskeyword+=-

" tmp directory
set directory=~/.vim/tmp
set backupdir=~/.vim/tmp
set undodir=~/.vim/tmp
" tags directory
set tags+=.git/tags

" Ruby settings {{{
" hoge? が1個の単語として認識されるようにする
autocmd FileType ruby setl iskeyword+=?
" }}}
" SQL syntax setting
let g:sql_type_default='mysql'

" 折りたたみ設定
" ファイルをオープンするとき重いので無効に
" set foldmethod=syntax
" set foldlevel=1
" set foldnestmax=2
" autocmd InsertEnter * if !exists('w:last_fdm')
"             \| let w:last_fdm=&foldmethod
"             \| setlocal foldmethod=manual
"             \| endif
" autocmd InsertLeave,WinLeave * if exists('w:last_fdm')
"             \| let &l:foldmethod=w:last_fdm
"             \| unlet w:last_fdm
"             \| endif

