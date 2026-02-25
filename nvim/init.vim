" --- Basic Settings ---
set number
set shortmess+=I
set splitbelow
set splitright
set clipboard=unnamedplus
set scrolloff=4
set encoding=utf-8

" --- Indentation ---
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent

" --- Ensure vim-plug is available in Neovim ---
set runtimepath^=~/.local/share/nvim/site
runtime autoload/plug.vim

" --- Filetype detection & indentation ---
filetype plugin indent on

" Always show line numbers in normal file buffers (undo splash window-local settings)
augroup ForceLineNumbers
  autocmd!
  autocmd BufEnter,WinEnter *
        \ if &buftype ==# '' && &filetype !=# '' |
        \   setlocal number |
        \ endif
augroup END

" --- Plugins (vim-plug) ---
" NOTE: This assumes vim-plug is installed.
" Neovim: ~/.local/share/nvim/site/autoload/plug.vim
" Vim:    ~/.vim/autoload/plug.vim
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

call plug#begin('~/.local/share/nvim/plugged')
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'jiangmiao/auto-pairs'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }
call plug#end()

" --- Colors & Syntax ---
if has('termguicolors')
  set termguicolors
endif
syntax on

" Colorscheme fallback
try
  colorscheme catppuccin_frappe
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
endtry

" --- UI Tweaks / Highlights ---
" (If your terminal doesn't support GUI colors, these won't hurt; they just may not show as intended.)
highlight Comment guifg=#a6adc8 ctermfg=248

" Transparency-like look (works best in terminals with transparent background configured)
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guifg=#a6adc8 guibg=NONE

" Cursor line
set cursorline
highlight CursorLineNr guifg=#e5c890 gui=bold
highlight CursorLine guibg=NONE ctermbg=NONE

" Status & messages
highlight ModeMsg      guifg=#8caaee guibg=NONE gui=bold
highlight MsgArea      guifg=#c6d0f5 guibg=NONE ctermbg=NONE
highlight MsgSeparator guibg=NONE

" Statusline configuration
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set laststatus=2

highlight StatusLine   guifg=#e5c890 guibg=#292c3c gui=bold
highlight StatusLineNC guifg=#a6adc8 guibg=#292c3c gui=NONE

" Split separators
highlight WinSeparator guifg=#414559 guibg=NONE
highlight VertSplit    guifg=#414559 guibg=NONE
set fillchars+=vert:│

" Darker background for file explorer
highlight NvimTreeNormal guibg=#292c3c
highlight NvimTreeNormalNC guibg=#292c3c
highlight NvimTreeEndOfBuffer guibg=#292c3c
highlight NvimTreeWinSeparator guifg=#414559 guibg=#292c3c

" --- Quick File Manager ---
nnoremap <leader>e :Ex<CR>

" =========================
" ASCII Splashscreen (Vim + Neovim)
" =========================

autocmd VimEnter * if argc() == 0 | call MySplash() | endif

function! MySplash() abort
  enew
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal signcolumn=no foldcolumn=0 nowrap colorcolumn= nonumber norelativenumber

  let l:logo = [
        \ '                   .@@@@@@@@@@@@@@@@@@@@+                   ',
        \ '                    .@@@@@.          .@@@                   ',
        \ '                      +@@@@#           .@                   ',
        \ '                       .@@@@@.          @.                  ',
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
        \ '                     — Leonardo da Vinci —',
        \ ]

  call timer_start(80, {-> MySplashShow(l:logo)})
endfunction

function! MySplashShow(logo) abort
  " Define highlight group used for the floating splash
  highlight MySplashFloat guibg=NONE guifg=#c6d0f5

  if has('nvim')
    " -------------------------
    " Neovim floating window
    " -------------------------
    let l:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(l:buf, 0, -1, v:true, a:logo)

    " Make buffer unlisted + nofile
    call nvim_buf_set_option(l:buf, 'buftype', 'nofile')
    call nvim_buf_set_option(l:buf, 'bufhidden', 'wipe')
    call nvim_buf_set_option(l:buf, 'swapfile', v:false)
    call nvim_buf_set_option(l:buf, 'modifiable', v:false)

    " Compute width/height
    let l:height = len(a:logo)
    let l:width = 0
    for l:line in a:logo
      if strdisplaywidth(l:line) > l:width
        let l:width = strdisplaywidth(l:line)
      endif
    endfor

    " Add padding
    let l:pad_y = 1
    let l:pad_x = 2
    let l:win_h = l:height + (2 * l:pad_y)
    let l:win_w = l:width  + (2 * l:pad_x)

    " Center on screen (clamp to >= 0)
    let l:row = float2nr((&lines - l:win_h) / 2.0)
    if l:row < 0 | let l:row = 0 | endif

    let l:col = float2nr((&columns - l:win_w) / 2.0)
    if l:col < 0 | let l:col = 0 | endif

    let l:opts = {
          \ 'relative': 'editor',
          \ 'row': l:row,
          \ 'col': l:col,
          \ 'width': l:win_w,
          \ 'height': l:win_h,
          \ 'style': 'minimal',
          \ 'focusable': v:false,
          \ 'border': 'none'
          \ }

    let g:mysplash_winid = nvim_open_win(l:buf, v:false, l:opts)

    " Apply highlight to the window background
    call nvim_win_set_option(g:mysplash_winid, 'winhl', 'Normal:MySplashFloat,NormalFloat:MySplashFloat')
    " Keep it non-interactive
    call nvim_win_set_option(g:mysplash_winid, 'cursorline', v:false)
  else
    " -------------------------
    " Vim popup (Vim 8+)
    " -------------------------
    let g:mysplash_id = popup_create(a:logo, {
          \ 'pos': 'center',
          \ 'zindex': 300,
          \ 'padding': [1,2,1,2],
          \ 'highlight': 'MySplashFloat',
          \ 'focusable': 0,
          \ 'border': [0,0,0,0],
          \ })
  endif

  let g:mysplash_armed = 0
  augroup MySplashAuto
    autocmd!
    autocmd CursorMoved,CursorMovedI,InsertEnter,TextChanged,TextChangedI,WinNew,BufReadPost *
          \ if get(g:, 'mysplash_armed', 0) | call MySplashClose() | endif
  augroup END

  call timer_start(150, {-> execute('let g:mysplash_armed = 1')})
endfunction

function! MySplashClose() abort
  if has('nvim')
    if exists('g:mysplash_winid') && g:mysplash_winid > 0
      if nvim_win_is_valid(g:mysplash_winid)
        silent! call nvim_win_close(g:mysplash_winid, v:true)
      endif
    endif
    if exists('g:mysplash_winid') | unlet g:mysplash_winid | endif
  else
    if exists('g:mysplash_id') && g:mysplash_id > 0
      silent! call popup_close(g:mysplash_id)
    endif
    if exists('g:mysplash_id') | unlet g:mysplash_id | endif
  endif

  if exists('g:mysplash_armed') | unlet g:mysplash_armed | endif
  if exists('#MySplashAuto') | autocmd! MySplashAuto | augroup! MySplashAuto | endif

  " If we are still in the empty buffer, replace it with a fresh empty buffer
  if &l:buftype ==# 'nofile' && bufname('%') == ''
    enew
  endif
endfunction

lua << EOF
-- Neovim 0.11+: native LSP config
vim.lsp.config.clangd = {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.lsp.start(vim.lsp.config.clangd)
  end,
})
EOF

lua << EOF
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
EOF

lua << EOF
vim.lsp.config.pyright = { cmd = { "pyright-langserver", "--stdio" }, filetypes = { "python" } }

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.lsp.start(vim.lsp.config.pyright)
  end,
})
EOF

lua << EOF
require("nvim-tree").setup({
  hijack_netrw = true,
  view = { width = 42, side = "left" },
  renderer = {
    indent_markers = { enable = true },
    icons = { show = { file = true, folder = true, folder_arrow = true, git = true } },
  },
  filters = { dotfiles = false },
})
EOF

nnoremap <leader>e :NvimTreeToggle<CR>
command! Vex NvimTreeToggle
command! Ex  NvimTreeToggle

augroup NvimTreeThemeFix
  autocmd!
  autocmd ColorScheme * highlight NvimTreeNormal guibg=#292c3c
  autocmd ColorScheme * highlight NvimTreeNormalNC guibg=#292c3c
  autocmd ColorScheme * highlight NvimTreeEndOfBuffer guibg=#292c3c
  autocmd ColorScheme * highlight NvimTreeWinSeparator guifg=#414559 guibg=#292c3c
augroup END
