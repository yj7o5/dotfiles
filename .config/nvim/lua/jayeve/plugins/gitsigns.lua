-- import gitsigns plugin safely
local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- configure/enable gitsigns
gitsigns.setup()
