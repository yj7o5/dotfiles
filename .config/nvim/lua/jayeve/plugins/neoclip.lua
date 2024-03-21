-- import neoclip plugin safely
local status, neoclip = pcall(require, "neoclip")
if not status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

neoclip.setup({
	enable_persistent_history = true,
})
