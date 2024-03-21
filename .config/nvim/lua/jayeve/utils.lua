local M = {}

function M.check_lsp_client_active(name)
	local clients = vim.lsp.get_active_clients()
	for _, client in pairs(clients) do
		if client.name == name then
			return true
		end
	end
	return false
end

function M.define_augroups(definitions) -- {{{1
	-- Create autocommand groups based on the passed definitions
	--
	-- The key will be the name of the group, and each definition
	-- within the group should have:
	--    1. Trigger
	--    2. Pattern
	--    3. Text
	-- just like how they would normally be defined from Vim itself
	for group_name, definition in pairs(definitions) do
		vim.cmd("augroup " .. group_name)
		vim.cmd("autocmd!")

		for _, def in pairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			vim.cmd(command)
		end

		vim.cmd("augroup END")
	end
end

M.define_augroups({
	_general_settings = {
		{ "TextYankPost", "*", "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})" },
		{ "BufWinEnter", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
		{ "BufRead", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
		{ "BufNewFile", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
		{ "VimLeavePre", "*", "set title set titleold=" },
	},
	-- _solidity = {
	--     {'BufWinEnter', '.sol', 'setlocal filetype=solidity'}, {'BufRead', '*.sol', 'setlocal filetype=solidity'},
	--     {'BufNewFile', '*.sol', 'setlocal filetype=solidity'}
	-- },
	-- _gemini = {
	--     {'BufWinEnter', '.gmi', 'setlocal filetype=markdown'}, {'BufRead', '*.gmi', 'setlocal filetype=markdown'},
	--     {'BufNewFile', '*.gmi', 'setlocal filetype=markdown'}
	-- },
	_markdown = { { "FileType", "markdown", "setlocal wrap" }, { "FileType", "markdown", "setlocal spell" } },
	_auto_resize = {
		-- will cause split windows to be resized evenly if main window is resized
		{ "VimResized", "*", "wincmd =" },
	},
	_qf = {
		-- will cause split windows to be resized evenly if main window is resized
		{ "FileType", "qf", "set nobuflisted" },
	},
	-- _fterm_lazygit = {
	--   -- will cause esc key to exit lazy git
	--   {"TermEnter", "*", "call LazyGitNativation()"}
	-- },
	-- _mode_switching = {
	--   -- will switch between absolute and relative line numbers depending on mode
	--   {'InsertEnter', '*', 'if &relativenumber | let g:ms_relativenumberoff = 1 | setlocal number norelativenumber | endif'},
	--   {'InsertLeave', '*', 'if exists("g:ms_relativenumberoff") | setlocal relativenumber | endif'},
	--   {'InsertEnter', '*', 'if &cursorline | let g:ms_cursorlineoff = 1 | setlocal nocursorline | endif'},
	--   {'InsertLeave', '*', 'if exists("g:ms_cursorlineoff") | setlocal cursorline | endif'},
	-- },
})

vim.cmd([[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
endfunction
]])

local function find_git_root()
	local dot_git_path = vim.fn.finddir(".git", ".;")
	local is_git_project = vim.fn.fnamemodify(dot_git_path, ":t") == ".git"
	return is_git_project and vim.fn.fnamemodify(vim.fn.fnamemodify(dot_git_path, ":p"), ":h:h") or nil
end

local function on_dir_changed()
	local cwd = vim.fn.getcwd()
	vim.notify("cwd changed to → " .. cwd, vim.log.levels.INFO, { title = "jayeve.utils" })
end

vim.api.nvim_create_autocmd({ "DirChanged" }, {
	callback = on_dir_changed,
})

function M.file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

function M.cd_to_git_root()
	local git_root = find_git_root()
	if git_root then
		vim.cmd.cd(git_root)
	else
		vim.notify("Git root not found.", vim.log.levels.ERROR, { title = "jayeve.utils" })
	end
end

function M.show_cur_location()
	local current_buffer = vim.api.nvim_get_current_buf()
	local file_path = vim.api.nvim_buf_get_name(current_buffer)
	local empty_file = string.len(file_path) == 0
	local file_str = empty_file and "[Empty Buf]" or file_path
	local cur_dir = vim.loop.cwd()
	vim.notify("cur file → " .. file_str .. "\ncur dir → " .. cur_dir, vim.log.levels.INFO, {
		title = "jayeve.utils",
	})
end

function M.cd_to_current_buf_directory()
	local bufname = vim.api.nvim_buf_get_name(0)
	local buffer_directory = bufname:match("^(.*)/[^/]-$")

	if buffer_directory then
		vim.cmd.cd(buffer_directory)
	else
		vim.notify(
			"Error: Unable to determine directory for current buffer.",
			vim.log.levels.ERROR,
			{ title = "jayeve.utils" }
		)
	end
end

local function is_blank(bufnr)
	bufnr = bufnr or 0 -- Default to current buffer if bufnr is not provided
	local bufname = vim.fn.bufname(bufnr)
	if vim.fn.empty(bufname) == 1 then
		-- Buffer is unnamed, now check if it's empty
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		for _, line in ipairs(lines) do
			if not vim.trim(line) == "" then
				return false -- Non-empty line found, buffer is not empty
			end
		end
		return true -- All lines are empty, buffer is empty and unnamed
	else
		return false -- Buffer has a name, so it's not both empty and unnamed
	end
end

local function exist_other_buffers(target_bufnr)
	local buf_list = vim.fn.getbufinfo({ buflisted = 1 })
	for _, buf_info in ipairs(buf_list) do
		if buf_info.bufnr ~= target_bufnr then
			return true
		end
	end
	return false
end

local function is_empty_vim()
	local current_bufnr = vim.fn.bufnr("")
	return is_blank(current_bufnr) and not exist_other_buffers(current_bufnr)
end

-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
-- 	callback = function()
-- 		if is_empty_vim() then
-- 			require("telescope").extensions.zoxide.list()
-- 			-- require("telescope.builtin").oldfiles()
-- 			-- vim.cmd("Telescope frecency")
-- 		end
-- 	end,
-- })

return M
