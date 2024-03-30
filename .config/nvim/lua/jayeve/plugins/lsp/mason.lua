-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- enable mason
mason.setup({
	log_level = vim.log.levels.OFF,
})

mason_lspconfig.setup({
	-- list of servers for mason to install
	ensure_installed = {
		"tsserver",
		"html",
		"cssls",
		"tailwindcss",
		"lua_ls",
		"rust_analyzer",
		"pyright",
		"clangd",
		"gopls",
	},
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
})

mason_null_ls.setup({
	-- list of formatters & linters for mason to install
	ensure_installed = {
		"rustfmt", -- rust formatter
		"prettier", -- ts/js formatter
		"stylua", -- lua formatter
		"eslint_d", -- ts/js linter
	},
	-- auto-install configured formatters & linters (with null-ls)
	automatic_installation = true,
})
