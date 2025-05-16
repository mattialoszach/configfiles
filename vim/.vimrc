set number

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

	highlight Normal guibg=NONE ctermbg=NONE
	highlight LineNr guifg=#7f849c guibg=NONE

	set cursorline
	highlight CursorLineNr guifg=#e5c890 gui=bold
	highlight CursorLine guibg=NONE ctermbg=NONE

	" Autopairs Plugin
	Plug 'jiangmiao/auto-pairs'
	call plug#end()
endif
