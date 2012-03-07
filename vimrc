filetype off
silent! call pathogen#runtime_append_all_bundles()
silent! call pathogen#helptags()
filetype plugin indent on


set nocompatible

set number
set ruler
syntax on

" Set encoding
set encoding=utf-8

" Tabs and spaces stuff
set wrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Tabs and trailing spaces
" http://vimcasts.org/episodes/show-invisibles/
set list
set list listchars=tab:▸\ ,trail:·
" Set mapleader
let mapleader=","
let g:mapleader=","
nmap <leader>l :set list!<CR>

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc

" Status bar
set laststatus=2
"set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%v%)\ %p
"set statusline=%m\{%{&ff}:%{&fenc}:%Y:%#NowBuf#%t%#StatusLine#}\ %{g:bufPartStr}%<%=%l,%c,%P,%L%<
"set statusline=%m\{%{&ff}:%{&fenc}:%{fugitive#statusline()}%=%=%<%=%l,%c,%P,%L%<
set statusline=%m%{&ff}:%{fugitive#statusline()}%=%=%<%=%l,%c,%P,%L%<
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
" syntastic plugin
let g:syntastic_enable_signs=1

" mouse on!
set mouse=a

" AESTHETICS 
"set t_Co=256 " 256bit color 
"

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$']
map <Leader>nt :NERDTreeToggle<CR>

" Command-T configuration
let g:CommandTMaxHeight=20

" ZoomWin configuration
map <Leader><Leader> :ZoomWin<CR>

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
" Buffer close
map <Leader>bd :bd<CR>

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=72
endfunction

function s:setupMarkup()
  call s:setupWrapping()
  map <buffer> <Leader>p :Mm <CR>
endfunction

" make and python use real tabs
au FileType make set noexpandtab
au FileType python setlocal noexpandtab
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
au FileType ruby setlocal ts=2 sts=2 sw=2 expandtab

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
"map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
"map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
color vividchalk

" Directories for swp files
set backupdir=~/.vim/.vim-backup
set directory=~/.vim/.vim-backup

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" utility function to preserve cursor position
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" show and trim spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
"set matchpairs=(:),{:},[:],<:>
"set whichwrap=b,s,<,>,[,]
set foldmethod=indent

function ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end 
  return oldhlsearch
endfunction

"function! <SID>TrimSpaces()
"   " Preparation: save last search, and cursor position.
"   let _s=@/
"   let l = line(".")
"   let c = col(".")
"   " Do the business:
"   %s/\s\+$//ec
"   " Clean up: restore previous search history, and cursor position
"   let @/=_s
"   call cursor(l, c)
"endfunction

command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
nnoremap <F12>     :ShowSpaces 1<CR>
"nnoremap <silent> <F5> :call <SID>TrimSpaces()<CR>
nmap <F5> :call Preserve("%s/\\s\\+$//ec")<CR>
nmap <F6> :call Preserve("normal gg=G")<CR>

" tabs shortcuts
" map <C-S-]> gt
" map <C-S-[> gT
" map <C-1> 1gt
" map <C-2> 2gt
" map <C-3> 3gt
" map <C-4> 4gt
" map <C-5> 5gt
" map <C-6> 6gt
" map <C-7> 7gt
" map <C-8> 8gt
" map <C-9> 9gt
" map <C-0> :tablast<CR>

"set <F20>=[25~
"set <F13>=[25~1
"set <F14>=[25~2
"
"map <F13> 1gt
"map <F14> 2gt
"
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>
" NERDTree setting
nmap <silent> <leader>nt :NERDTree<cr>
let NERDTreeIgnore=['\.rbc$', '\~$']
map <Leader>n :NERDTreeToggle<CR>

" Most Recently Used (MRU)
nmap <silent> <leader>r :MRU<cr>

" FuzzyFinder setting
nmap <leader>fb :FufBuffer<cr>
nmap <leader>ff :FufFile<cr>
nmap <leader>fd :FufDir<cr>
nmap <leader>fa :FufBookmark<cr>


map <silent> <leader>rc :tabe ~/.vim/vimrc<cr>
map <leader>q :q<cr>
" Specky
" let g:speckyBannerKey        = "<C-S>b"
" let g:speckyQuoteSwitcherKey = "<C-S>'"
" let g:speckyRunRdocKey       = "<C-S>r"
" let g:speckySpecSwitcherKey  = "<C-S>x"
" let g:speckyRunSpecKey       = "<C-S>s"
let g:speckyBannerKey        = "<leader>sb"
let g:speckyQuoteSwitcherKey = "<leader>s'"
let g:speckyRunRdocKey       = "<leader>sr"
let g:speckySpecSwitcherKey  = "<leader>sx"
let g:speckyRunSpecKey       = "<leader>ss"
let g:speckyRunRdocCmd       = "fri -L -f plain"
let g:speckyWindowType       = 2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MacVim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("gui_macvim")

	set columns=171
	set lines=58
	winpos 52 42 

	let macvim_skip_cmd_opt_movement = 1
	let macvim_hig_shift_movement = 1

	set transparency=8
	set guioptions-=T "egmrt
	"set guioptions+=b 
	
	macm File.New\ Tab						key=<D-T>
	macm File.Save<Tab>:w					key=<D-s>
	macm File.Save\ As\.\.\.<Tab>:sav		key=<D-S>
	macm Edit.Undo<Tab>u					key=<D-z> action=undo:
	macm Edit.Redo<Tab>^R					key=<D-Z> action=redo:
	macm Edit.Cut<Tab>"+x					key=<D-x> action=cut:
	macm Edit.Copy<Tab>"+y					key=<D-c> action=copy:
	macm Edit.Paste<Tab>"+gP				key=<D-v> action=paste:
	macm Edit.Select\ All<Tab>ggVG			key=<D-A> action=selectAll:
	macm Window.Toggle\ Full\ Screen\ Mode	key=<D-F>
	macm Window.Select\ Next\ Tab			key=<D-}>
	macm Window.Select\ Previous\ Tab		key=<D-{>
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd! bufwritepost .vimrc source ~/.vimrc
autocmd! bufwritepost vimrc source ~/.vimrc
"autocmd BufRead * :lcd! %:p:h


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! GetMySession(spath, ssname)
	if a:ssname == 0
		let a:sname = ""
	else
		let a:sname = "-".a:ssname
	endif
	execute "source $".a:spath."/session".a:sname.".vim"
	execute "rviminfo $".a:spath."/session".a:sname.".viminfo"
	execute "echo \"Load Success\: $".a:spath."/session".a:sname.".vim\""
endfunction

function! SetMySession(spath, ssname)
	if a:ssname == 0
		let a:sname = ""
	else
		let a:sname = "-".a:ssname
	endif
	execute "cd $".a:spath
	execute "mksession! $".a:spath."/session".a:sname.".vim"
	execute "wviminfo! $".a:spath."/session".a:sname.".viminfo"
	execute "echo \"Save Success\: $".a:spath."/session".a:sname.".vim\""
endfunction
" load session from path
command! -nargs=+ LOAD call GetMySession(<f-args>) 
" save session
command! -nargs=+ SAVE call SetMySession(<f-args>) 
