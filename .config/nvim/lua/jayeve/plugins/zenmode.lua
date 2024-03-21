-- import zenmode plugin safely
local setup, zenmode = pcall(require, "zenmode")
if not setup then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- enable zenmode
zenmode.setup({
	plugins = {
		tmux = { enable = true },
	},
})
