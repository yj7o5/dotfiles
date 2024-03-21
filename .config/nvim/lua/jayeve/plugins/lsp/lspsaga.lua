-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

saga.setup({})
