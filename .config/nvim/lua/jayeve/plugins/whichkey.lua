local function safeCall(import)
	local status, import_ = pcall(require, import)
	if not status then
		local info = debug.getinfo(1, "S").short_src
		print(info .. " failed to load " .. import)
	end
	return import_
end

local harpoon_mark = safeCall("harpoon.mark")
local harpoon_ui = safeCall("harpoon.ui")
local lualine_nightfly = safeCall("lualine.themes.nightfly")
local jayeve = safeCall("jayeve.utils")

local function togglePurple()
	if vim.g.colors_name == "neovim_purple" then
		vim.cmd("colorscheme gruvbox")
		require("lualine").setup({
			options = {
				theme = lualine_nightfly,
			},
		})
	else
		vim.cmd("colorscheme neovim_purple")
		require("lualine").setup({
			options = {
				theme = "neovim_purple",
			},
		})
	end
end

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>")

-- clear search highlights
keymap.set("n", ";", function()
	vim.cmd("nohlsearch")
end)

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- search with double tap of space bar
keymap.set("n", "<leader><leader>", "/")

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader><tab>", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>r", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>c", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>o", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>n", "<cmd>Telescope help_tags<cr>") -- list available help tags
keymap.set("n", "<leader>h", "<cmd>Telescope oldfiles<cr>") -- list previously opened files
keymap.set("n", "<leader>L", "<cmd>Telescope jumplist<cr>") -- list of previous cursor positions
keymap.set("n", "<leader>j", "<cmd>Telescope zoxide list<cr>") -- list projects by recentcy, using zoxide
keymap.set("n", "<leader>y", "<cmd>Telescope neoclip<cr>") -- list yank history
keymap.set("n", "<leader>f", "<cmd>Telescope file_browser<cr>") -- open file file_browser switch to folder browser with ctrl-f
keymap.set("n", "<leader>k", "<cmd>Telescope frecency<cr>") -- file frecency
keymap.set("n", "<leader>u", "<cmd>Telescope harpoon marks<cr>") -- harpoon marks
keymap.set("n", "<leader>m", "<cmd>Telescope metals commands<cr>")

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]
keymap.set("n", "<leader>d", "<cmd>Telescope command_history<cr>")

local which_key = safeCall("which-key")
local gitlinker = safeCall("gitlinker")
local actions = safeCall("gitlinker.actions")

which_key.register({
	["<leader>"] = {
		C = {
			jayeve.copy_file_path_to_clipboard,
			"Copy cur buffer filepath",
		},
		g = {
			name = "git",
		},
		p = {
			togglePurple,
			"Toggle Purple Display",
		},
		b = {
			jayeve.get_cloudflare_source_link,
			"generate bitbucket link",
		},
		a = {
			function()
				vim.api.nvim_call_function("ToggleRTL", {})
			end,
			"Toggle Arabic (Left -> Right) mode",
		},
		i = {
			name = "Harpoon",
			a = { harpoon_mark.add_file, "add file to harpoon" },
			r = { harpoon_mark.remove_file, "remove file from harpoon" },
			l = { harpoon_ui.toggle_quick_menu, "Toggle quick menu" },
		},
		q = {
			function()
				vim.cmd("bdelete")
			end,
			"close current buffer",
		},
		B = {
			function()
				gitlinker.get_repo_url({ action_callback = actions.open_in_browser })
			end,
			"open ref link in browser",
		},
		z = {
			function()
				vim.cmd("ZenMode")
			end,
			"Zen mode",
		},
	},
	["<leader>="] = {
		function()
			vim.api.nvim_input("<C-w>=")
		end,
		"equalize windows",
	},
	["<leader>g."] = {
		-- use nvim_create_user_command("NameOfCommand")and put in a standalon file
		jayeve.cd_to_git_root,
		"cd into cur buf's git root",
	},
	["<leader>."] = {
		jayeve.cd_to_current_buf_directory,
		"cd into cur buf's dir",
	},
	["<c-g>"] = {
		jayeve.show_cur_location,
		"show current location",
	},
	-- ["g"] = {
	-- 	t = {
	-- 		function()
	-- 			vim.cmd("BufferLineCycleNext")
	-- 		end,
	-- 		"BufferLineCycleNext",
	-- 	},
	-- 	T = {
	-- 		function()
	-- 			vim.cmd("BufferLineCyclePrev")
	-- 		end,
	-- 		"BufferLineCyclePrev",
	-- 	},
	-- },
	["<leader>]"] = {
		function()
			vim.cmd("cnext")
		end,
		"Next in quickfix list",
	},
	["<leader>["] = {
		function()
			vim.cmd("cprev")
		end,
		"Prev in quickfix list",
	},
})
which_key.register({
	["<leader>b"] = {
		jayeve.get_cloudflare_source_link,
		"generate bitbucket link",
	},
}, { mode = "v" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		keymap.set("n", ",qi", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>", opts)
		keymap.set("n", ",qo", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>", opts)
		keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		keymap.set("n", "gd", "<cmd> lua vim.lsp.buf.definition()<cr>", opts)
		keymap.set("n", "K", "<cmd> lua vim.lsp.buf.hover()<cr>", opts)
		keymap.set("n", "gI", "<cmd> lua vim.lsp.buf.implementation()<cr>", opts)
		keymap.set("n", "<C-m>", "<cmd> lua vim.lsp.buf.signature_help()<cr>", opts)
		keymap.set("n", "<leader>wa", "<cmd> lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
		keymap.set("n", "<leader>wr", "<cmd> lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
		keymap.set("n", "<space>D", "<cmd> lua vim.lsp.buf.type_definition()<cr>", opts)
		-- keymap.set("n", ",rn", "<cmd> lua vim.lsp.buf.rename<cr>()", opts)
		keymap.set({ "n", "v" }, ",ca", "<cmd> lua vim.lsp.buf.code_action()<cr>", opts)
		keymap.set("n", "gR", "<cmd> lua vim.lsp.buf.references()<cr>", opts)
		keymap.set("n", ",rs", ":LspRestart<cr>")
		which_key.register({
			[",rn"] = {
				function()
					vim.lsp.buf.rename()
				end,
				"rename variable",
			},
			["<leader>"] = {
				F = {
					function()
						vim.lsp.buf.format({ async = true })
					end,
					"Foramt buffer (async)",
					buffer = ev.buf,
				},
				["wl"] = {
					function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end,
					"list workspace folder",
				},
			},
		}, { mode = "n" })
	end,
})
