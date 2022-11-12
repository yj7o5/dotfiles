-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

-- import telescope actions safely
local zoxide_setup, z_utils = pcall(require, "telescope._extensions.zoxide.utils")
if not zoxide_setup then
	return
end

-- configure telescope
telescope.setup({
	-- configure custom mappings
	defaults = {
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- move to prev result
				["<C-j>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
	},
	extensions = {
		zoxide = {
			prompt_title = "[ Cd in directory (recentcy) ]",
			mappings = {
				default = {
					after_action = function(selection)
						print("Update to (" .. selection.z_score .. ") " .. selection.path)
					end,
				},
				["<C-s>"] = {
					before_action = function(selection)
						print("before C-s")
					end,
					action = function(selection)
						vim.cmd("edit " .. selection.path)
					end,
				},
				-- Opens the selected entry in a new split
				["<C-q>"] = { action = z_utils.create_basic_command("split") },
			},
		},
		project = {
			prompt_title = "cd to Project root",
			base_dirs = {
				"~/discord/discord",
				"~/discord/discord/discord_api",
				"~/discord/discord/discord_app",
				"~/.vim",
				"~/.config/nvim",
			},
			hidden_files = true,
			sync_with_nvim_tree = true,
		},
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
		bookmarks = {
			selected_browser = "firefox",
			url_open_command = "open",
		},
		-- You don't need to set any of these options.
		-- IMPORTANT!: this is only a showcase of how you can set default options!
		file_browser = {
			theme = "ivy",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
			mappings = {
				-- ["i"] = {
				-- 	-- your custom insert mode mappings
				-- },
				-- ["n"] = {
				-- 	-- your custom normal mode mappings
				-- },
			},
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("zoxide")
telescope.load_extension("project")
telescope.load_extension("neoclip")
telescope.load_extension("bookmarks")
telescope.load_extension("gh")
telescope.load_extension("file_browser")
telescope.load_extension("frecency")
