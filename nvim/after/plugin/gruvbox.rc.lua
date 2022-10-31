local status, gruvbox = pcall(require, "gruvbox")

gruvbox.setup ({
  transparent_mode = false
})

vim.cmd[[colorscheme gruvbox]]
