source $VIMRUNTIME/defaults.vim

"Vundle Stuff"
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim


call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'drewtempelmeyer/palenight.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'ap/vim-buftabline'
Plugin 'mhinz/vim-startify'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'

call vundle#end()


filetype plugin indent on
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
"End Vundle Stuff"

set autoindent
set tabstop=8
set softtabstop=4
set shiftwidth=4
set noexpandtab
set mouse=a
syntax on
set background=dark
set number
colorscheme palenight
let g:palenight_terminal_italics=1

if (has("nvim"))
	"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
	set termguicolors
endif

map <C-o> :NERDTreeToggle<CR>

autocmd BufNewFile,BufRead *.cpp set formatprg=astyle\ -T4pb

"execute pathogen#infect()
"call pathogen#helptags()

function! Format()
	silent! execute 'norm! mz'

	if &ft ==? 'c' || &ft ==? 'cpp' || &ft ==? 'php'
		set formatprg=astyle\ --mode=c
		silent! execute 'norm! gggqG'
	elseif &ft ==? 'java'
		set formatprg=astyle\ --mode=java
		silent! execute 'norm! gggqG'
	endif

	silent! call RemoveTrailingSpaces()
	silent! execute 'retab'
	silent! execute 'gg=G'
	silent! execute 'norm! `z'
	set formatprg=
endfunction

function! RemoveTrailingSpaces()
	silent! execute '%s/\s\+$//ge'
	silent! execute 'g/\v^$\n*%$/norm! dd'
endfunction

function FileHeading()
  let s:line=line(".")
  call setline(s:line,"/*")
  call append(s:line+0," * Program:		".expand('%:t')." - Title")
  call append(s:line+1," * Author:		Nick Olson")
  call append(s:line+2," * Date:		".strftime("%m/%d/%Y"))
  call append(s:line+3," * Description:	")
  call append(s:line+4," */")
  unlet s:line
endfunction

function FunctionHeading()
  let s:line=line(".")
  call setline(s:line,"/*                                                                                      -")
  call append(s:line+0," * Function:		")
  call append(s:line+1," * Description:		")
  call append(s:line+2," * Parameters:		")
  call append(s:line+3," * Return Value:	")
  call append(s:line+4," * Pre-Conditions:	All fields instantiated.")
  call append(s:line+5," * Post-Conditions:	")
  call append(s:line+6," */")
  unlet s:line
endfunction

imap <leader>program <Esc>mz:execute FileHeading()<CR>`zjjjj$A
imap <leader>function <Esc>mz:execute FunctionHeading()<CR>`zj$A

map <silent> <c-f> :call Format()<CR>

let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
set completeopt-=preview

set shortmess+=c

"Ctrl-P Settings
set runtimepath^=~/.vim/bundle/ctrlp.vim
set tags+=doc/tags
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_extensions = ['buffertag', 'dir', 'line']
"End Ctrl-P Settings

"Startify stuff
function s:my_sessions()
    let s_files = split(globpath('./doc/sessions', '*'), '\n')
    return map(s_files, '{"line": v:val, "cmd": "source". v:val }')
endfunction


let g:startify_lists = [
	    \ { 'header': ['   Doc Sessions'],	'type': function('s:my_sessions') },
	    \ { 'type': 'files',	'header': ['   MRU']            },
	    \ { 'type': 'dir',		'header': ['   MRU '. getcwd()] },
	    \ { 'type': 'sessions',	'header': ['   Sessions']       },
	    \ { 'type': 'bookmarks',	'header': ['   Bookmarks']      },
	    \ { 'type': 'commands',	'header': ['   Commands']       },
	    \ ]
"End Startify
