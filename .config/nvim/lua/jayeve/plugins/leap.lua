local status, leap = pcall(require, "leap")
if not status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward-to)")
vim.keymap.set({ "n", "x", "o" }, "H", "<Plug>(leap-backward)")
vim.keymap.set({ "n", "x", "o" }, "H", "<Plug>(leap-backward-to)")

leap.opts.special_keys.prev_target = "<bs>"
leap.opts.special_keys.prev_group = "<bs>"
require("leap.user").set_repeat_keys("<cr>", "<bs>")
