-- in case it isn't installed
local gruvbox_status, _ = pcall(vim.cmd, "colorscheme gruvbox")
if not gruvbox_status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load gruvbox") -- print error if colorscheme not installed
	return
end
