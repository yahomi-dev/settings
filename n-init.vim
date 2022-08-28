"" set options
set number
set shell=/bin/zsh
set shiftwidth=2
set tabstop=2
set expandtab
set textwidth=0
set autoindent
set hlsearch
set clipboard=unnamed

nmap <C-[> :noh<CR>

" 行間を移動させる
nmap j gj
nmap k gk

noremap <S-h> ^
noremap <S-j> }
noremap <S-k> {
noremap <S-l> $

"" インサートモード内でemacsカーソル移動
inoremap <C-f> <right>
inoremap <C-b> <left>

" 補完の選択と被るので退避
" inoremap <C-p> <Up>
" inoremap <C-n> <Down>

"" インサートモードから抜けた時に英数入力モードに移行
autocmd InsertLeave * :silent !/opt/homebrew/bin/im-select com.apple.keylayout.ABC


""" ここからNeovim専用設定
if !exists('g:vscode')

" Install Plugin
call plug#begin('~/.config/nvim/plugged')

Plug 'vim-jp/vimdoc-ja'
Plug 'junegunn/fzf', {'dir': '~/.fzf_bin', 'do': './install --all'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'editorconfig/editorconfig-vim'

" text edit
Plug 'machakann/vim-sandwich'
Plug 'cohama/lexima.vim'

" Fern + extensions
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/gina.vim'

" lualua 
Plug 'nvim-lualine/lualine.nvim'
Plug 'norcalli/nvim-colorizer.lua'

" colorschemes
Plug 'Luxed/ayu-vim'
call plug#end()

" ayu color setting
set termguicolors       " enable true colors support

set background=dark     " for either mirage or dark version.

" let g:ayucolor="mirage" " for mirage version of theme



" map prefix
let g:mapleader = "\<Space>"
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>
nnoremap [dev]    <Nop>
xnoremap [dev]    <Nop>
nmap     m        [dev]
xmap     m        [dev]
nnoremap [ff]     <Nop>
xnoremap [ff]     <Nop>
nmap     z        [ff]
xmap     z        [ff]

"" coc.nvim
let g:coc_global_extensions = ['coc-tsserver', 'coc-eslint8', 'coc-prettier', 'coc-git', 'coc-fzf-preview', 'coc-lists']

inoremap <silent> <expr> <C-Space> coc#refresh()
nnoremap <silent> [dev]k       :<C-u>call <SID>show_documentation()<CR>
nmap     <silent> [dev]rn <Plug>(coc-rename)
nmap     <silent> [dev]a  <Plug>(coc-codeaction-selected)iw

" Enterで補完を展開
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

function! s:coc_typescript_settings() abort
  nnoremap <silent> <buffer> [dev]f :<C-u>CocCommand eslint.executeAutofix<CR>:CocCommand prettier.formatFile<CR>
endfunction

augroup coc_ts
  autocmd!
  autocmd FileType typescript,typescriptreact call <SID>coc_typescript_settings()
augroup END

function! s:show_documentation() abort
  if index(['vim','help'], &filetype) >= 0
    execute 'h ' . expand('<cword>')
  elseif coc#rpc#ready()
    call CocActionAsync('doHover')
  endif
endfunction

" popupが出る場合の対処 with ゴリラさん
call lexima#init()
inoremap <silent><expr> <CR> coc#pum#visible() ? <nop> : <nop>

function! s:coc_pum_lexima_enter() abort
  let key = lexima#expand('<CR>', 'i')
  call coc#on_enter()
  return "\<C-g>u" . key
endfunction

augroup coc-pum-enter
  au!
  au InsertEnter * inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : <SID>coc_pum_lexima_enter()
augroup END


"" lexima
let g:filetype_js_ts = ['vue', 'javascriptreact', 'javascript', 'typescript', 'typescriptreact']

call lexima#add_rule({ 'filetype': filetype_js_ts, 'char': '>', 'at': '\s([a-zA-Z, ]*\%#)',            'input': '<Left><C-o>f)<Right>a=> {}<Esc>',                 })
call lexima#add_rule({ 'filetype': filetype_js_ts, 'char': '>', 'at': '\s([a-zA-Z]\+\%#)',             'input': '<Right> => {}<Left>',              'priority': 10 })
call lexima#add_rule({ 'filetype': filetype_js_ts, 'char': '>', 'at': '[a-z]((.*\%#.*))',              'input': '<Left><C-o>f)a => {}<Esc>',                       })
call lexima#add_rule({ 'filetype': filetype_js_ts, 'char': '>', 'at': '[a-z]([a-zA-Z]\+\%#)',          'input': ' => {}<Left>',                                    })
call lexima#add_rule({ 'filetype': filetype_js_ts, 'char': '>', 'at': '(.*[a-zA-Z]\+<[a-zA-Z]\+>\%#)', 'input': '<Left><C-o>f)<Right>a=> {}<Left>',                })


autocmd InsertEnter * inoremap <expr> <CR> coc#pum#visible() ? coc#pum#confirm() : <SID>coc_pum_lexima_enter()

"" fzf-preview
nnoremap <silent> <C-p>  :<C-u>CocCommand fzf-preview.FromResources buffer project_mru project<CR>
nnoremap <silent> [ff]s  :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [ff]gg :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [ff]b  :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap          [ff]f  :<C-u>CocCommand fzf-preview.ProjectGrep --add-fzf-arg=--exact --add-fzf-arg=--no-sort<Space>
xnoremap          [ff]f  "sy:CocCommand fzf-preview.ProjectGrep --add-fzf-arg=--exact --add-fzf-arg=--no-sort<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"

nnoremap <silent> [ff]q  :<C-u>CocCommand fzf-preview.CocCurrentDiagnostics<CR>
nnoremap <silent> [ff]rf :<C-u>CocCommand fzf-preview.CocReferences<CR>
nnoremap <silent> [ff]d  :<C-u>CocCommand fzf-preview.CocDefinition<CR>
nnoremap <silent> [ff]t  :<C-u>CocCommand fzf-preview.CocTypeDefinition<CR>
nnoremap <silent> [ff]o  :<C-u>CocCommand fzf-preview.CocOutline --add-fzf-arg=--exact --add-fzf-arg=--no-sort<CR>

"" fern
nnoremap <silent> <Leader>e :<C-u>Fern . -drawer -reveal=% -width=40 -toggle<CR>
nnoremap <silent> <Leader>E :<C-u>Fern . -drawer<CR>

let g:fern#renderer = 'nerdfont'

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

"" treesitter
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "typescript",
    "tsx",
  },
  highlight = {
    enable = true,
  },
}
EOF

"" lualine
lua <<EOF
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { 
      -- left = '', right = ''
      },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {
        'filename',
        path = 1,
        file_status = true,
        shorting_target = 40,

        symbols = {
         modified = ' [+]',
         readonly = ' [RO]',
         unnamed = 'Untitled',
         newfile = '[New]', 
       }
      }
    },

    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
    },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
EOF

" colorizer
lua <<EOF
local colorizer = require('colorizer')
colorizer.setup()
EOF


"" colorschemes

colorscheme ayu


endif

