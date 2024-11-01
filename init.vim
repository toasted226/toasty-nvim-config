:set tabstop=4
:set shiftwidth=4

let mapleader = " "

call plug#begin('~/AppData/Local/nvim/plugged')

Plug 'https://github.com/neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'nvim-lua/plenary.nvim'
Plug 'BurntSushi/ripgrep'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }

Plug 'https://github.com/cocopon/iceberg.vim'

call plug#end()

:colorscheme iceberg

nnoremap <silent> <leader>ff :lua require('telescope.builtin').find_files()<CR>
nnoremap <silent> <leader>fr :lua require('telescope.builtin').oldfiles()<CR>
nnoremap <silent> <leader>g :lua require('telescope.builtin').live_grep()<CR>
nnoremap <silent> <leader>b :lua require('telescope.builtin').buffers()<CR>

nnoremap <leader>t :terminal powershell<CR>

lua << EOF
local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
	window = {

	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' }
	}, {
		{ name = 'buffer' }	
	})
})

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
  		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['gopls'].setup {
capabilities = capabilities
}

require'lspconfig'.gopls.setup{
	cmd = { "gopls" },
	settings = {
		gopls = {
			usePlaceholders = true,
			completeUnimported = true,
		},
	},
}
EOF
