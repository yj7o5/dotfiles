-- import neoclip plugin safely
local status, neoclip = pcall(require, "neoclip")
if not status then
	return
end

neoclip.setup({
	enable_persistent_history = true,
})
