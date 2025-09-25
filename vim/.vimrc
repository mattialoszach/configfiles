" ---Basis---
set number
set shortmess+=I

" ---Theme & Plugin (only for non Apple Standard Terminal)---
if $TERM_PROGRAM !=# "Apple_Terminal"
	syntax on
	set autoindent

	call plug#begin('~/.vim/plugged')

	" Catppuccin Theme
	Plug 'catppuccin/vim', { 'as': 'catppuccin' }

	call plug#end()

	" Theme aktivieren
	set termguicolors
	syntax on
	colorscheme catppuccin_frappe
	
	highlight Comment guifg=#a6adc8 ctermfg=248

	highlight Normal guibg=NONE ctermbg=NONE
	highlight LineNr guifg=#a6adc8 guibg=NONE

	set cursorline
	highlight CursorLineNr guifg=#e5c890 gui=bold
	highlight CursorLine guibg=NONE ctermbg=NONE

	" Autopairs Plugin
	Plug 'jiangmiao/auto-pairs'
	call plug#end()
endif

" ---Custom ASCII Splashscreen---
set shortmess+=I

autocmd VimEnter * if argc() == 0 | call MySplash() | endif

function! MySplash()
  enew
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal signcolumn=no foldcolumn=0 nowrap colorcolumn=

  " Custom Logo
  let l:logo = [
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
