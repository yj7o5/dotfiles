vim.g.codeowners_airline_enabled = false
-- import codeowners safely
local status, codeowners = pcall(require, "codeowners")
if not status then
	return
end

-- vim.cmd([[let g:codeowners_airline_enabled = v:false]])
codeowners.setup()
