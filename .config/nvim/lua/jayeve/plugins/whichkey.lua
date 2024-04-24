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
keymap.set("n", "<leader>l", "<cmd>Telescope jumplist<cr>") -- list of previous cursor positions
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

keymap.set("n", ",r", "<cmd>Lspsaga rename<CR>") -- smart rename
-- LSP finder - Find the symbol's definition
-- If there is no definition, it will instead be hidden
-- When you use an action in finder like "open vsplit",
-- you can use <C-t> to jump back
keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>")

-- Code action
keymap.set({ "n", "v" }, ",ca", "<cmd>Lspsaga code_action<CR>")

-- Rename all occurrences of the hovered word for the entire file
keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>")

-- Rename all occurrences of the hovered word for the selected files
keymap.set("n", "gr", "<cmd>Lspsaga rename ++project<CR>")

-- Peek definition
-- You can edit the file containing the definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
-- keymap.set("n", "<leader>gd", "<cmd>Lspsaga peek_definition<CR>")

-- Go to definition
keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>")

-- Show line diagnostics
-- You can pass argument ++unfocus to
-- unfocus the show_line_diagnostics floating window
keymap.set("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

-- Show cursor diagnostics
-- Like show_line_diagnostics, it supports passing the ++unfocus argument
keymap.set("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

-- Show buffer diagnostics
keymap.set("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

-- Diagnostic jump
-- You can use <C-o> to jump back to your previous location
keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

-- Diagnostic jump with filters such as only jumping to an error
keymap.set("n", "[E", function()
	require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap.set("n", "]E", function()
	require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end)

-- Toggle outline
keymap.set("n", ",o", "<cmd>Lspsaga outline<CR>")

-- Hover Doc
-- If there is no hover doc,
-- there will be a notification stating that
-- there is no information available.
-- To disable it just use ":Lspsaga hover_doc ++quiet"
-- Pressing the key twice will enter the hover window
keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")

-- If you want to keep the hover window in the top right hand corner,
-- you can pass the ++keep argument
-- Note that if you use hover with ++keep, pressing this key again will
-- close the hover window. If you want to jump to the hover window
-- you should use the wincmd command "<C-w>w"
keymap.set("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")

-- Call hierarchy
keymap.set("n", ",ci", "<cmd>Lspsaga incoming_calls<CR>")
keymap.set("n", ",co", "<cmd>Lspsaga outgoing_calls<CR>")

-- Floating terminal
keymap.set({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
-- restart lsp server (not on youtube nvim video)
-- keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

keymap.set({ "n" }, "<leader>z", "<cmd>ZenMode<cr>")

local which_key = safeCall("which-key")
local gitlinker = safeCall("gitlinker")
local actions = safeCall("gitlinker.actions")

which_key.register({
	[",q"] = {
		i = {
			vim.lsp.buf.incoming_calls,
			"incoming_calls quickfix list",
		},
		o = {
			vim.lsp.buf.outgoing_calls,
			"outgoing_calls quickfix list",
		},
		n = {
			function()
				vim.cmd("cnext")
			end,
			"Forward quickfix list",
		},
		p = {
			function()
				vim.cmd("cprev")
			end,
			"Backward quickfix list",
		},
	},
	["<leader>"] = {
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
})
which_key.register({
	["<leader>b"] = {
		jayeve.get_cloudflare_source_link,
		"generate bitbucket link",
	},
}, { mode = "v" })
