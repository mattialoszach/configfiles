" ---Basis---
set number
set shortmess+=I
set splitbelow splitright
set clipboard=unnamed
set scrolloff=4

"  ---Theme & Plugin (only for non Apple Standard Terminal)---
if $TERM_PROGRAM !=# "Apple_Terminal"
	syntax on
	set autoindent

	call plug#begin('~/.vim/plugged')

	" Catppuccin Theme
	Plug 'catppuccin/vim', { 'as': 'catppuccin' }

	call plug#end()

	" Activate Theme
	set termguicolors
	syntax on
	colorscheme catppuccin_frappe
	
	highlight Comment guifg=#a6adc8 ctermfg=248

	highlight Normal guibg=NONE ctermbg=NONE
	highlight LineNr guifg=#a6adc8 guibg=NONE

	set cursorline
	highlight CursorLineNr guifg=#e5c890 gui=bold
	highlight CursorLine guibg=NONE ctermbg=NONE
	
	highlight ModeMsg      guifg=#8caaee  guibg=#2e3340 gui=bold
	highlight MsgArea      guifg=#c6d0f5 guibg=#343a48
	highlight MsgSeparator                 guibg=#343a48

	" Statusline
	set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
	set laststatus=2
	set termguicolors
	
	highlight StatusLine guifg=#e5c890 gui=bold
	highlight StatusLineNC    guifg=#a6adc8 guibg=#292c3c gui=NONE

	highlight WinSeparator    guifg=#414559 guibg=#303446
	highlight VertSplit       guifg=#414559 guibg=#292c3c
	set fillchars+=vert:\│

	" Autopairs Plugin
	Plug 'jiangmiao/auto-pairs'
	call plug#end()	
endif

" ---Custom ASCII Splashscreen---
autocmd VimEnter * if argc() == 0 | call MySplash() | endif

function! MySplash()
  enew
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal signcolumn=no foldcolumn=0 nowrap colorcolumn=

  " Custom Logo
  let l:logo = [
      \ '                  .@@@@@@@@@@@@@@@@@@@@+                    ',
      \ '                   .@@@@@.          .@@@                    ',
      \ '                     +@@@@#           .@                    ',
      \ '                      .@@@@@.          @.                   ',
      \ '                        .@@@@@.                             ',
      \ '                          .@@@@@                            ',
      \ '                            @@@                             ',
      \ '                           @@.                              ',
      \ '                         .@@            @.                  ',
      \ '                       .@@.            @@                   ',
      \ '                      @@@@@@@@@@@@@@@@@@@                   ',
      \ '                    .@@@@@@@@@@@@@@@@@@@.                   ',
      \ '                                                            ',
      \ '                                                            ',
      \ '██╗   ██╗██╗███╗   ███╗ █████╗ ████████╗████████╗██╗ █████╗ ',
      \ '██║   ██║██║████╗ ████║██╔══██╗╚══██╔══╝╚══██╔══╝██║██╔══██╗',
      \ '██║   ██║██║██╔████╔██║███████║   ██║      ██║   ██║███████║',
      \ '╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██║   ██║      ██║   ██║██╔══██║',
      \ ' ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║   ██║      ██║   ██║██║  ██║',
      \ '  ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═╝',
      \ '',
      \ '      “Simplicity is the ultimate sophistication.”',
      \ '                        — Leonardo da Vinci —',
      \ ]

  call timer_start(80, {-> MySplashShow(l:logo)})
endfunction

function! MySplashShow(logo)
  highlight default link MySplashFloat NormalFloat
  let g:mysplash_id = popup_create(a:logo, {
        \ 'pos': 'center',
        \ 'zindex': 300,
        \ 'padding': [0,0,0,0],
        \ 'highlight': 'MySplashFloat',
        \ 'focusable': 0
        \ })

  let g:mysplash_armed = 0
  augroup MySplashAuto
    autocmd!
    autocmd CursorMoved,CursorMovedI,InsertEnter,TextChanged,TextChangedI,ModeChanged,WinNew,BufReadPost *
          \ if get(g:, 'mysplash_armed', 0) | call MySplashClose() | endif
  augroup END
  call timer_start(150, {-> execute('let g:mysplash_armed = 1')})
endfunction

function! MySplashClose()
  if exists('g:mysplash_id') && g:mysplash_id > 0
    silent! call popup_close(g:mysplash_id)
  endif
  if exists('g:mysplash_id') | unlet g:mysplash_id | endif
  if exists('g:mysplash_armed') | unlet g:mysplash_armed | endif

  if exists('#MySplashAuto') | autocmd! MySplashAuto | augroup! MySplashAuto | endif

  if &l:buftype ==# 'nofile'
    enew
  endif
endfunction
