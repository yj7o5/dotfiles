-- import windex plugin safely
local status, windex = pcall(require, "windex")
if not status then
	return
end

windex.setup({
	default_keymaps = false,
	save_buffers = false,
})
