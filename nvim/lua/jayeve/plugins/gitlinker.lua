-- import gitlinker plugin safely
local setup, gitlinker = pcall(require, "gitlinker")
if not setup then
	return
end

-- configure/enable gitlinker
gitlinker.setup()
