-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

local keymap = vim.keymap -- for conciseness

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
})

-- configure typescript server with plugin
typescript.setup({
	server = {
		capabilities = capabilities,
		root_dir = require("lspconfig.util").root_pattern(".git"),
		filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
		cmd = { "typescript-language-server", "--stdio" },
	},
})

-- make bash-lsp work with zsh (nvim builtin-lsp)
lspconfig["bashls"].setup({
	-- completion = ...,
	filetypes = { "sh", "zsh", "bash" },
})

-- lspconfig.yamlls.setup({
-- 	settings = {
-- 		yaml = {
-- 			format = { enable = true },
-- 			keyOrdering = false,
-- 		},
-- 	},
-- })
vim.filetype.add({
	extension = {
		zsh = "sh",
		sh = "sh", -- force sh-files with zsh-shebang to still get sh as filetype
	},
	filename = {
		[".zshrc"] = "sh",
		[".zshenv"] = "sh",
	},
})

-- confgure golong
lspconfig.gopls.setup({
	capabilities = capabilities,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "goworkd", "gotmpl" },
	root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			-- https://github.com/bazel-contrib/rules_go/wiki/Editor-setup
			env = {
				GOPACKAGESDRIVER = "./tools/gopackagesdriver.sh",
			},
			directoryFilters = {
				"-bazel-bin",
				"-bazel-out",
				"-bazel-testlogs",
				"-bazel-mypkg",
			},
		},
	},
})

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
})

-- configure lua server (with special settings)
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

lspconfig["clangd"].setup({})

lspconfig["intelephense"].setup({})

lspconfig.ruff_lsp.setup({
	init_options = {
		settings = {
			-- Any extra CLI arguments for `ruff` go here.
			args = {},
		},
	},
})

lspconfig.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {},
	},
})

lspconfig.pyright.setup({
	settings = {
		pyright = { autoImportCompletion = true },
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "off",
			},
		},
	},
})
