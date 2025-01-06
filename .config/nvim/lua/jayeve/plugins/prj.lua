local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local Job = require("plenary.job")
-- local previewers = require("telescope.previewers")

local M = {}

local function contains(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

local function get_tmux_sessions()
	local sessions = {}
	local handle = io.popen("tmux list-sessions -F '#S'")

	if handle then
		for session in handle:lines() do
			table.insert(sessions, session)
		end
		handle:close()
	end

	return sessions
end

local function prj_helper(team, project)
	local starting_dir = vim.fn.getcwd()

	local base = os.getenv("HOME") .. "/cloudflare"
	if vim.fn.isdirectory(base) == 0 then
		print("creating " .. base)
		vim.fn.mkdir(base, "p")
	end

	local team_dir = base .. "/" .. team
	local project_dir = team_dir .. "/" .. project

	if vim.fn.isdirectory(project_dir) == 0 then
		-- check if project exists on bitbucket
		local gitlab_url = "git@gitlab.cfdata.org:cloudflare/" .. team .. "/" .. project .. ".git"

		-- Try cloning the repository from gitlab
		local gitlab_ls_remote = "git ls-remote " .. gitlab_url .. " > /dev/null 2>&1"
		local gitlab_success = os.execute(gitlab_ls_remote)

		if gitlab_success then
			print("INFO: checking gitlab for " .. team_dir)
			if vim.fn.isdirectory(team_dir) == 0 then
				print("INFO: creating directory " .. team_dir)
				vim.fn.mkdir(team_dir, "p")
			end

			print("INFO: cloning " .. gitlab_url .. " into " .. project_dir)
			os.execute("git clone " .. gitlab_url .. " " .. project_dir)
		else
			local bitbucket_url = "ssh://git@bitbucket.cfdata.org:7999/" .. team .. "/" .. project .. ".git"
			print("Cloning from Gitlab failed. Falling back to bitbucket")
			local bitbucket_success = "git ls-remote " .. bitbucket_url .. " > /dev/null 2>&1"
			if bitbucket_success then
				print("INFO: checking gitlab for " .. team_dir)
				if vim.fn.isdirectory(team_dir) == 0 then
					print("INFO: creating directory " .. team_dir)
					vim.fn.mkdir(team_dir, "p")
				end

				print("INFO: cloning " .. bitbucket_url .. " into " .. project_dir)
				os.execute("git clone " .. bitbucket_url .. " " .. project_dir)
			else
				print("ERROR: project " .. bitbucket_url .. " does not exist in bitbucket")
				return 1
			end
		end
	end

	-- Check if tmux is running
	local tmux_running = os.execute("pgrep tmux > /dev/null 2>&1")
	if vim.env.TMUX == nil and tmux_running ~= 0 then
		os.execute("tmux new-session -s " .. project .. " -c " .. project_dir)
		return
	end

	-- Check if tmux session exists
	local session_exists = os.execute("tmux has-session -t=" .. project .. " 2>/dev/null")
	if session_exists ~= 0 then
		print("creating session " .. project .. " with root dir at " .. vim.fn.getcwd())
		os.execute("tmux new-session -d -s " .. project .. " -c " .. project_dir)
	end

	if vim.env.TMUX == nil then
		-- Attach to the new session
		os.execute("tmux attach-session -t " .. project .. " -c " .. project_dir)
	else
		-- Switch to the new session
		os.execute("tmux switch-client -t " .. project)
	end

	-- Check if the function failed
	if session_exists ~= 0 then
		vim.cmd("cd " .. starting_dir)
		return 1
	end
end

local function prj(team, project)
	if not team or not project then
		print("Usage: prj <team> <project>")
		print(
			"This attempts to open a work project. If the project is not present, it will clone and open in a tmux session."
		)
	else
		prj_helper(team, project)
	end
end

local function list_git_dirs(root_dir)
	local results = {}
	Job:new({
		command = "find",
		args = { root_dir, "-mindepth", "3", "-maxdepth", "3", "-type", "d", "-name", ".git" },
		on_exit = function(j)
			for _, dir in ipairs(j:result()) do
				-- remove the trailing "/.git" from the path
				local git_dir = string.gsub(dir, "/%.git$", "")
				-- Extract the last two parts of the path
				local parts = vim.split(git_dir, "/")
				local tuple = { parts[#parts - 1], parts[#parts] }
				table.insert(results, tuple)
			end
		end,
	}):sync()
	return results
end

local function split_input_on_whitespace(input)
	local result = {}
	for word in string.gmatch(input, "%S+") do
		table.insert(result, word)
	end
	return result
end

function M.git_dir_picker(root_dir)
	local tmux_sessions = get_tmux_sessions()
	pickers
		.new({}, {
			prompt_title = "Local CF Git Repositories",
			finder = finders.new_table({
				results = list_git_dirs(root_dir),
				entry_maker = function(entry)
					local display_name = table.concat(entry, "  ")
					if contains(tmux_sessions, entry[2]) then
						display_name = table.concat(entry, "  ") .. " ●"
					end
					return {
						value = entry,
						display = display_name,
						ordinal = table.concat(entry, "/"),
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(_, map)
				actions.select_default:replace(function(prompt_bufnr)
					local input = action_state.get_current_line()
					local selection = action_state.get_selected_entry()

					actions.close(prompt_bufnr)
					if selection then
						-- vim.notify(
						-- 	"Project → " .. selection.value[1] .. " Repo → " .. selection.value[2],
						-- 	vim.log.levels.INFO,
						-- 	{ title = "prj.lua" }
						-- )
						prj(selection.value[1], selection.value[2])
					else
						local split = split_input_on_whitespace(input)
						if #split == 2 then
							-- vim.notify(
							-- 	"Input: " .. split[1] .. " " .. split[2],
							-- 	vim.log.levels.INFO,
							-- 	{ title = "prj.lua" }
							-- )
							prj(split[1], split[2])
						end
					end
				end)
				return true
			end,
		})
		:find()
end

-- TODO export as a telescope extension
return M
