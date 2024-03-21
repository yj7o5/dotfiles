local status, silicon = pcall(require, "silicon")
if not status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

silicon.setup({
	font = "Hack Nerd Font",
	to_clipboard = true,
	tab_width = 2,
	theme = "gruvbox-dark", -- try `bat --list-themes` to see what available
	background = "#fff0", -- transparent
})

-- Generate image of lines in a visual selection
vim.keymap.set("v", "<Leader>s", "<cmd>Silicon<CR>")
