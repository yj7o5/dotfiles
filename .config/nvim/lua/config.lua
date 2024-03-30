-- set leader key to space
vim.g.mapleader = " "

-- keymaps, options, commands before plugins
vim.api.nvim_create_user_command("ReloadConfig", "source $MYVIMRC", {})
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("jayeve.plugins.whichkey")
		require("jayeve.core.options")
		require("jayeve.core.colorscheme")
	end,
})

local lazy = {}

function lazy.install(path)
	if not vim.loop.fs_stat(path) then
		print("Installing lazy.nvim....")
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			path,
		})
	end
end

function lazy.setup(plugins)
	if vim.g.plugins_ready then
		return
	end

	-- You can "comment out" the line below after lazy.nvim is installed
	lazy.install(lazy.path)

	vim.opt.rtp:prepend(lazy.path)

	require("lazy").setup(plugins, lazy.opts)
	vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
lazy.opts = {}

lazy.setup({

	-- Theme plugins
	{ "yeddaif/neovim-purple" },
	{ "kyazdani42/nvim-web-devicons" }, -- vs-code like icons
	{ "ellisonleao/gruvbox.nvim" }, -- preferred colorscheme
	{ "nvim-lualine/lualine.nvim" },
	{ "MunifTanjim/nui.nvim" }, -- component library
	{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
	{
		"folke/noice.nvim", -- floating command prompt and error messages
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{ "folke/zen-mode.nvim" },
	{ "ellisonleao/glow.nvim", config = true, cmd = "Glow" }, -- markdown fanciness

	-- navigation plugins
	{ "christoomey/vim-tmux-navigator" }, -- tmux & split window navigation
	{ "szw/vim-maximizer" }, -- maximizes and restores current window
	{ "ggandor/leap.nvim" }, -- S keymap conflicts with vim-surround
	{ "nvim-tree/nvim-tree.lua" }, -- file explorer
	{
		"ThePrimeagen/harpoon",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

	-- essential plugins
	{ "tpope/vim-surround" }, -- add, delete, change surroundings (it's awesome)
	{ "nvim-lua/plenary.nvim" }, -- lua functions that many plugins use
	{ "numToStr/Comment.nvim" }, -- commenting with gc
	{ "kkharji/sqlite.lua" },
	{ "tpope/vim-fugitive" }, -- fugitive (git operations)
	-- use("vim-scripts/ReplaceWithRegister") -- replace with register contents using motion (gr + motion)

	-- telescope
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-github.nvim" },
		},
		branch = "0.1.x",
	},
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{
		"nvim-telescope/telescope-frecency.nvim",
		dependencies = { "kkharji/sqlite.lua" },
	},
	{
		"AckslD/nvim-neoclip.lua", -- clipboard
		dependencies = {
			{ "nvim-telescope/telescope.nvim", branch = "0.1.x" },
			{ "kkharji/sqlite.lua" },
		},
	},
	{ "jvgrootveld/telescope-zoxide" }, -- fancy 'cd' command, z
	{
		"dhruvmanila/telescope-bookmarks.nvim", -- web bookmarks
		version = "*",
		-- Uncomment if the selected browser is Firefox, Waterfox or buku
		dependencies = {
			"kkharji/sqlite.lua",
		},
	},

	-- autocompletion
	{ "hrsh7th/nvim-cmp" }, -- completion plugin
	{ "hrsh7th/cmp-buffer" }, -- source for text in buffer
	{ "hrsh7th/cmp-path" }, -- source for file system paths

	-- snippets
	{ "L3MON4D3/LuaSnip" }, -- snippet engine
	{ "saadparwaiz1/cmp_luasnip" }, -- for autocompletion
	{ "rafamadriz/friendly-snippets" }, -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	{ "williamboman/mason.nvim" }, -- in charge of managing lsp servers, linters & formatters
	{ "williamboman/mason-lspconfig.nvim" }, -- bridges gap b/w mason & lspconfig

	-- coc for ts because native lsp is too slow
	-- { "neoclide/coc.nvim", branch = "release", ft = { "typescriptreact", "typescript" } },

	-- configuring lsp servers
	{ "astral-sh/ruff-lsp" },
	{ "neovim/nvim-lspconfig" }, -- easily configure language servers
	{ "hrsh7th/cmp-nvim-lua" }, -- for autocompletion
	{ "hrsh7th/cmp-nvim-lsp" }, -- LSP completion source
	{ "hrsh7th/cmp-nvim-lsp-signature-help" }, -- for autocompletion
	{ "hrsh7th/cmp-vsnip" }, -- for autocompletion
	{ "hrsh7th/vim-vsnip" }, -- for autocompletion
	{ "glepnir/lspsaga.nvim", branch = "main" }, -- enhanced lsp uis
	{ "jose-elias-alvarez/typescript.nvim" }, -- additional functionality for typescript server (e.g. rename file & update imports)
	{ "onsails/lspkind.nvim" }, -- vs-code like icons for autocompletion

	-- formatting & linting
	{ "jose-elias-alvarez/null-ls.nvim" }, -- configure formatters & linters
	{ "jayp0521/mason-null-ls.nvim" }, -- bridges gap b/w mason & null-ls

	-- treesitter configuration
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context" },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- auto closing
	{ "windwp/nvim-autopairs" }, -- autoclose parens, brackets, quotes, etc...
	-- use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	{ "lewis6991/gitsigns.nvim" }, -- show line modifications on left hand side
	{ "ruifm/gitlinker.nvim", dependencies = "nvim-lua/plenary.nvim" },

	-- vim-abolish: change snake-case to underscore_case or camelCase
	{ "tpope/vim-abolish" },

	-- rust
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
	},
	{ "simrat39/rust-tools.nvim", dependencies = { "neovim/nvim-lspconfig" } },
	{ "rust-lang/rust.vim" },

	{ "michaelrommel/nvim-silicon" },
	{ "yever/rtl.vim" },

	-- for scala IDE-like features
	{
		"scalameta/nvim-metals",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			"SmiteshP/nvim-navic",
			"hrsh7th/cmp-nvim-lua",
		},
	},
	{ "lewis6991/hover.nvim" },
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
	},
})

-- configure aforementioned plugins
require("jayeve.plugins.noice")
require("jayeve.plugins.comment")
require("jayeve.plugins.nvim-tree")
require("jayeve.plugins.lualine")
require("jayeve.plugins.telescope")
require("jayeve.plugins.nvim-cmp")
require("jayeve.plugins.lsp.mason")
require("jayeve.plugins.lsp.lspsaga")
require("jayeve.plugins.lsp.lspconfig")
require("jayeve.plugins.lsp.null-ls")
require("jayeve.plugins.autopairs")
require("jayeve.plugins.gitlinker")
require("jayeve.plugins.treesitter")
require("jayeve.plugins.treesitter-objects")
require("jayeve.plugins.gitsigns")
require("jayeve.plugins.neoclip")
require("jayeve.plugins.rust-tools")
require("jayeve.plugins.rust-lang")
require("jayeve.plugins.silicon")
require("jayeve.plugins.metals")
require("jayeve.plugins.hover")
require("jayeve.plugins.leap")
require("jayeve.plugins.harpoon")
require("jayeve.plugins.bufferline")
require("jayeve.plugins.zenmode")
require("jayeve.plugins.glow")
require("jayeve.plugins.obsidian")
require("jayeve.utils")

-- require("jayeve.plugins.coc")
