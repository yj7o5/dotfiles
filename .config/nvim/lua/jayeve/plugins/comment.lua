-- import comment plugin safely
local setup, comment = pcall(require, "Comment")
if not setup then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- enable comment
comment.setup()
