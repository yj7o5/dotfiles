local status, obsidian = pcall(require, "obsidian")
if not status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end
obsidian.setup({
	workspaces = {
		{
			name = "personal",
			path = "~/vaults/personal",
		},
		{
			name = "work",
			path = "~/cloudflare/vaults/work",
		},
	},
})
