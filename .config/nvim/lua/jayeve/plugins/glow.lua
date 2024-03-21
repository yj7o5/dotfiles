local status, glow = pcall(require, "glow")
if not status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

glow.setup({
	style = "dark",
})
