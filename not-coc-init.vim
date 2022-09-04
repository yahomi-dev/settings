set confirm
set number
set encoding=utf-8
set shell=/bin/zsh
set shiftwidth=2
set tabstop=2
set expandtab
set textwidth=0
set autoindent
set hlsearch
set clipboard=unnamed

" ファイル系
set noundofile
set noswapfile
set nobackup
set autoread

" VSCode風ターミナル
tnoremap <C-[> <C-\><C-n>
command! -nargs=* T split | wincmd j | resize 17 | terminal <args>

nmap <C-[> :noh<CR>

" Leaderキーの再定義
let g:mapleader = "\<Space>"
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>

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
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'editorconfig/editorconfig-vim'

" lsp plugins
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'

" telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

" git information
Plug 'lewis6991/gitsigns.nvim'

" buffer line 
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }

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
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'lukas-reineke/indent-blankline.nvim'

" colorschemes
Plug 'Luxed/ayu-vim'
call plug#end()

" ayu color setting
set termguicolors

set background=dark

let g:ayucolor="mirage"

"" map prefix
nnoremap [lsp]    <Nop>
xnoremap [lsp]    <Nop>
nmap     m        [lsp]
xmap     m        [lsp]
nnoremap [fzf]     <Nop>
xnoremap [fzf]     <Nop>
nmap     z        [fzf]
xmap     z        [fzf]

"" lsp configs
lua << EOF
local mason = require('mason')
mason.setup({
 ui = {
   icons = {
     package_installed = "✓",
     package_pending = "➜",
     package_uninstalled = "✗"
   }
 }
})

local nvim_lsp = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup_handlers({ function(server_name)
 local opts = {}
 opts.on_attach = function(_, bufnr)
   local bufopts = { silent = true, buffer = bufnr }
   vim.keymap.set('[lsp]', 'K', vim.lsp.buf.hover, bufopts)
   vim.keymap.set('[lsp]', 'gd', vim.lsp.buf.definition, bufopts)
   vim.keymap.set('[lsp]', 'ga', vim.lsp.buf.code_action, bufopts)
   vim.keymap.set('[lsp]', 'gtD', vim.lsp.buf.type_definition, bufopts)
   vim.keymap.set('[lsp]', 'rf', vim.lsp.buf.references, bufopts)
   vim.keymap.set('[lsp]', 'f', vim.lsp.buf.format, bufopts)
end
 nvim_lsp[server_name].setup(opts)
end })

-- cmp settings
local cmp = require('cmp')
cmp.setup({
  snippet = {},
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  },
  {
    { name = "buffer" },
  })
})
EOF


" telescope
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap [fzf]g <cmd>Telescope live_grep<cr>
nnoremap [fzf]b <cmd>Telescope buffers<cr>
nnoremap [fzf]h <cmd>Telescope help_tags<cr>

lua << EOF
require("bufferline").setup{}
EOF


" gitsigns
lua << EOF
 require('gitsigns').setup {
 signs = {
   add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
   change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
   delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
   topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
   changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
 },
 signcolumn = true,
 numhl      = false,
 linehl     = false,
 word_diff  = false,
 watch_gitdir = {
   interval = 1000,
   follow_files = true
 },
 attach_to_untracked = true,
 current_line_blame = false,
 current_line_blame_opts = {
   virt_text = true,
   virt_text_pos = 'eol',
   delay = 1000,
   ignore_whitespace = false,
 },
 current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
 sign_priority = 6,
 update_debounce = 100,
 status_formatter = nil,
 max_file_length = 40000,
 preview_config = {
   border = 'single',
   style = 'minimal',
   relative = 'cursor',
   row = 0,
   col = 1
 },
 yadm = {
   enable = false
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
  }
EOF


"" lexima
let g:filetype_js_ts = ['vue', 'javascriptreact', 'javascript', 'typescript', 'typescriptreact']

call lexima#add_rule({ 'filetype': filetype_js_ts, 'char': '>', 'at': '\s([a-zA-Z, ]*\%#)',            'input': '<Left><C-o>f)<Right>a=> {}<Esc>',                 })
call lexima#add_rule({ 'filetype': filetype_js_ts, 'char': '>', 'at': '\s([a-zA-Z]\+\%#)',             'input': '<Right> => {}<Left>',              'priority': 10 })
call lexima#add_rule({ 'filetype': filetype_js_ts, 'char': '>', 'at': '[a-z]((.*\%#.*))',              'input': '<Left><C-o>f)a => {}<Esc>',                       })
call lexima#add_rule({ 'filetype': filetype_js_ts, 'char': '>', 'at': '[a-z]([a-zA-Z]\+\%#)',          'input': ' => {}<Left>',                                    })
call lexima#add_rule({ 'filetype': filetype_js_ts, 'char': '>', 'at': '(.*[a-zA-Z]\+<[a-zA-Z]\+>\%#)', 'input': '<Left><C-o>f)<Right>a=> {}<Left>',                })

"" fern
nnoremap <silent> <Leader>e :<C-u>Fern . -drawer -reveal=% -width=40 -toggle -keep<CR>

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
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
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

    lualine_x = {'filetype', 'encoding'},
    lualine_y = {
      {
        'diagnostics',
        source = {'nvim-lsp'},
      }
    },
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
  extensions = {}
}
EOF

" colorizer
lua <<EOF
local colorizer = require('colorizer')
colorizer.setup()
EOF

" indent-blankline 
lua <<EOF
local indent_bl = require("indent_blankline")
indent_bl.setup {
  -- for example, context is off by default, use this to turn it on
  show_current_context = true,
  show_current_context_start = true,
}
EOF


"" colorschemes
colorscheme ayu

endif
