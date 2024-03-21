-- import bufferline plugin safely
local status, bufferline = pcall(require, "bufferline")
if not status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

bufferline.setup({})
