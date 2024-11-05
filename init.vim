:set relativenumber
:set tabstop=4
:set shiftwidth=4

let mapleader = ","

call plug#begin('~/AppData/Local/nvim/plugged')

Plug 'https://github.com/neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'windwp/nvim-autopairs'
Plug 'https://github.com/windwp/nvim-ts-autotag'

Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'andweeb/presence.nvim'

Plug 'loctvl842/monokai-pro.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'BurntSushi/ripgrep'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }

call plug#end()

:colorscheme monokai-pro

nnoremap <silent> <leader>ff :lua require('telescope.builtin').find_files()<CR>
nnoremap <silent> <leader>fr :lua require('telescope.builtin').oldfiles()<CR>
nnoremap <silent> <leader>g :lua require('telescope.builtin').live_grep()<CR>
nnoremap <silent> <leader>b :lua require('telescope.builtin').buffers()<CR>
nnoremap <silent> <leader>pf :lua vim.lsp.buf.format { async = true }<CR>

nnoremap <leader>t :terminal powershell<CR>

highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight SignColumn guibg=NONE ctermbg=NONE

lua << EOF

-- Mason config
require('mason').setup()
require('mason-lspconfig').setup {
	ensure_installed = { "gopls", "pyright", "ts_ls", "rust_analyzer", "html", "angularls" },
	automatic_installation = true,
}

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(client, bufnr)
	-- LSP keybindings
	vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
end

-- This will handle all servers managed by mason-lspconfig
require('mason-lspconfig').setup_handlers {
    function(server_name)
        lspconfig[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
        }
    end,
}

---------------

-- Treesitter config

require'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "go", "rust", "python", "typescript", "html", "comment" },
	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true,

		additional_vim_regex_highlighting = false,
	},
}

---------------

-- cmp config

local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {

	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
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

---------------

-- autopairs setup
require("nvim-autopairs").setup {}

-- autotag setup
require('nvim-ts-autotag').setup({
	opts = {
		-- Defaults
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
		enable_close_on_slash = false -- Auto close on trailing </
	},
	-- Also override individual filetype configs, these take priority.
	-- Empty by default, useful if one of the "opts" global settings
	-- doesn't work well in a specific filetype
	per_filetype = {
		["html"] = {
			enable_close = false
		}
	}
})

---------------

-- Neovim Discord Presence config

require("presence").setup({
	-- General options
	neovim_image_text = "The One True Text Editor",
	buttons = false,
	enable_line_number = false,

	-- Rich Presence text options
	editing_text = "Editing %s",
	file_explorer_text = "Looking through %s",
	plugin_manager_text = "Fighting with vim plugins",
	workspace_text = "Hacking away at %s",
	line_number_text = "Line %s of %s",
})

EOF







