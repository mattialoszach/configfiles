" --- Basic Settings ---
set number
set shortmess+=I
set splitbelow splitright
set clipboard=unnamed
set scrolloff=4
set encoding=utf-8

" --- Theme & Plugins (only for non-Apple Terminal) ---
if $TERM_PROGRAM !=# "Apple_Terminal"
    
    " Initialize Plugins (everything between begin and end)
    call plug#begin('~/.vim/plugged')

    " Theme
    Plug 'catppuccin/vim', { 'as': 'catppuccin' }
    
    " Autopairs Plugin
    Plug 'jiangmiao/auto-pairs'

    call plug#end()

    " --- Design & Colors ---
    if has('termguicolors')
        set termguicolors
    endif
    syntax on
    
    " Catch error if theme is not installed (fallback to default)
    try
        colorscheme catppuccin_frappe
    catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme default
    endtry
    
    " Customize Highlights
    highlight Comment guifg=#a6adc8 ctermfg=248

    " Transparency (Important: Set MsgArea to NONE as well to avoid the bottom bar!)
    highlight Normal guibg=NONE ctermbg=NONE
    highlight LineNr guifg=#a6adc8 guibg=NONE
    
    " Cursor Line
    set cursorline
    highlight CursorLineNr guifg=#e5c890 gui=bold
    highlight CursorLine guibg=NONE ctermbg=NONE
    
    " Status & Messages
    highlight ModeMsg      guifg=#8caaee guibg=NONE gui=bold
    highlight MsgArea      guifg=#c6d0f5 guibg=NONE ctermbg=NONE
    highlight MsgSeparator guibg=NONE

    " Statusline Configuration
    set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
    set laststatus=2
    
    highlight StatusLine   guifg=#e5c890 guibg=#292c3c gui=bold
    highlight StatusLineNC guifg=#a6adc8 guibg=#292c3c gui=NONE

    " Split Separators
    highlight WinSeparator guifg=#414559 guibg=NONE
    highlight VertSplit    guifg=#414559 guibg=NONE
    set fillchars+=vert:│
endif

" --- Custom ASCII Splashscreen ---
autocmd VimEnter * if argc() == 0 | call MySplash() | endif

function! MySplash()
  enew
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal signcolumn=no foldcolumn=0 nowrap colorcolumn= nonumber norelativenumber

  " Custom Logo
  let l:logo = [
      \ '                  .@@@@@@@@@@@@@@@@@@@@+                    ',
      \ '                   .@@@@@.          .@@@                    ',
      \ '                    +@@@@#           .@                     ',
      \ '                     .@@@@@.         @.                     ',
      \ '                       .@@@@@.                              ',
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
      \ '                     — Leonardo da Vinci —',
      \ ]

  call timer_start(80, {-> MySplashShow(l:logo)})
endfunction

function! MySplashShow(logo)
  highlight default link MySplashFloat NormalFloat
  " Ensure Popup highlights are correct (transparent background)
  highlight MySplashFloat guibg=NONE guifg=#c6d0f5

  let g:mysplash_id = popup_create(a:logo, {
        \ 'pos': 'center',
        \ 'zindex': 300,
        \ 'padding': [1,2,1,2],
        \ 'highlight': 'MySplashFloat',
        \ 'focusable': 0,
        \ 'border': [0,0,0,0], 
        \ })

  let g:mysplash_armed = 0
  augroup MySplashAuto
    autocmd!
    autocmd CursorMoved,CursorMovedI,InsertEnter,TextChanged,TextChangedI,WinNew,BufReadPost *
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

  " Check if we are still in the empty buffer before calling enew
  if &l:buftype ==# 'nofile' && bufname('%') == ''
    enew
  endif
endfunction
