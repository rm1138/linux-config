let mapleader = "\<Space>"

set nocompatible
filetype plugin on

call plug#begin()

Plug 'easymotion/vim-easymotion'
Plug 'rust-lang/rust.vim'
Plug 'chriskempson/base16-vim'

" Git 
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'

" Plug 'preservim/nerdtree'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
"Plug 'peitalin/vim-jsx-typescript'
"Plug 'leafgarland/typescript-vim'
"Plug 'pangloss/vim-javascript'
Plug 'mracos/mermaid.vim'
Plug 'uarun/vim-protobuf'

Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Semantic language support
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
Plug 'hrsh7th/cmp-path', {'branch': 'main'}
Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
Plug 'ray-x/lsp_signature.nvim'

" Only because nvim-cmp _requires_ snippets
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'folke/lsp-colors.nvim'

call plug#end()

set updatetime=100

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" let base16colorspace=256
colorscheme base16-tomorrow-night-eighties

" rust
"let g:rustfmt_autosave = 1
"let g:rustfmt_emit_files = 1
"let g:rustfmt_fail_silently = 0
"let g:rust_clip_command = 'xclip -selection clipboard'

" netrw
let ghregex='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide=ghregex
let g:netrw_liststyle = 3

" markdown preview
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 1
    \ }
" set filetypes as typescriptreact
"autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact


" LSP configuration
lua << END
local lspconfig = require'lspconfig'

local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED by nvim-cmp. get rid of it once we can
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  },
  sources = cmp.config.sources({
    -- TODO: currently snippets from lsp end up getting prioritized -- stop that!
    { name = 'nvim_lsp' },
  }, {
    { name = 'path' },
  }),
  experimental = {
    ghost_text = true,
  },
})

-- Enable completing paths in :
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  })
})

-- Setup lspconfig.
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  if client.resolved_capabilities.document_formatting then
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  --buf_set_keymap('n', '<space>i', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>l", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- Get signatures (and _only_ signatures) when in argument lists.
  require "lsp_signature".on_attach({
    doc_lines = 0,
    handler_opts = {
      border = "none"
    },
  })
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
  capabilities = capabilities,
}

lspconfig.phpactor.setup {
  on_attach = on_attach
}

lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false


        local ts_utils = require("nvim-lsp-ts-utils")

        ts_utils.setup({
          enable_formatting = true
        })

        ts_utils.setup_client(client)        

        -- Mappings.
        local opts = { noremap=true, silent=true }

        buf_set_keymap("n", "gs", ":TSLspOrganize<CR>", opts)
        buf_set_keymap("n", "gi", ":TSLspRenameFile<CR>", opts)
        buf_set_keymap("n", "go", ":TSLspImportAll<CR>", opts) 
        on_attach(client, bufnr)
    end,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)

require("trouble").setup {

}

require("lsp-colors").setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})

local null_ls = require("null-ls")
null_ls.config({
    sources = {
        null_ls.builtins.diagnostics.eslint_d.with({ -- eslint or eslint_d
            prefer_local = "node_modules/.bin",
        }),
        null_ls.builtins.code_actions.eslint_d.with({ -- eslint or eslint_d
            prefer_local = "node_modules/.bin",
        }),
        null_ls.builtins.formatting.prettier.with({ -- prettier, eslint, eslint_d, or prettierd
            prefer_local = "node_modules/.bin",
        }),
    },
    debug = true
})

lspconfig["null-ls"].setup({ on_attach = on_attach })

END

" fzf
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" `f{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap f <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
"map <Leader>j <Plug>(easymotion-j)
"map <Leader>k <Plug>(easymotion-k)


" back to netrw with <Leader> + b
map <Leader>b :e %:h<CR>
map <Leader>f :GFiles<CR>
map <Leader>g :Ag<CR>
map <Leader>t :Windows<CR>
noremap <Leader>w :w<CR>
noremap <Leader>q :q<CR>

" system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

nmap <Leader>m <Plug>MarkdownPreviewToggle

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>

" Left and right can switch buffers
" nnoremap <left> :bp<CR>
" nnoremap <right> :bn<CR>

" Move by line
nnoremap j gj
nnoremap k gk

nnoremap <leader>x <cmd>TroubleToggle<cr>

vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

nnoremap <Leader>o <C-o>
nnoremap <Leader>i <C-i>

" Sane splits
set splitright
set splitbelow

set wildmenu

syntax enable

filetype plugin indent on
set number
set relativenumber
set nowrap
set autoindent

set tabstop=2
set shiftwidth=2
set expandtab

set foldmethod=syntax
set foldlevel=99

hi Normal ctermbg=None guibg=None

"function! GitStatus()
"  let [a,m,r] = GitGutterGetHunkSummary()
"  return printf('+%d ~%d -%d', a, m, r)
"endfunction
"set statusline+=%{GitStatus()}
