-- import zenmode plugin safely
local setup, zenmode = pcall(require, "zen-mode")
if not setup then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- enable zenmode
zenmode.setup({
	plugins = {
		alacritty = {
			enabled = true,
		},
	},
	on_open = function(_)
		vim.fn.system([[tmux set status off]])
		vim.fn.system([[tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z]])
		vim.opt.scl = "no"
	end,
	on_close = function(_)
		vim.fn.system([[tmux set status on]])
		vim.fn.system([[tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z]])
		vim.opt.scl = "yes"
	end,
})
