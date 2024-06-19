-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- configure treesitter
treesitter.setup({
	-- enable syntax highlighting
	highlight = {
		enable = true,
		disable = { "yaml" },
	},
	-- enable indentation
	indent = { enable = true },
	-- enable autotagging (w/ nvim-ts-autotag plugin)
	autotag = { enable = true },
	-- ensure these language parsers are installed
	ensure_installed = {
		"go",
		"bash",
		"regex",
		"rust",
		"toml",
		"lua",
		"json",
		"javascript",
		"typescript",
		"tsx",
		"yaml",
		"html",
		"css",
		"kotlin",
		"markdown",
		"markdown_inline",
		"svelte",
		"graphql",
		"bash",
		"vim",
		"dockerfile",
		"gitignore",
		"python",
	},
	-- auto install above language parsers
	auto_install = true,
})
