-- import rust-tools.nvim plugin safely
local status, rt = pcall(require, "rust-tools")
if not status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

rt.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", ",a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
})
