-- import indent blankline plugin safely
local status, ibl = pcall(require, "ibl")
if not status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- local highlight = { "CursorColumn", "Whitespace" }

ibl.setup({
	enabled = false,
	-- indent = { highlight = highlight, char = "" },
	-- whitespace = {
	-- 	highlight = highlight,
	-- 	remove_blankline_trail = false,
	-- },
	scope = { enabled = true },
})
