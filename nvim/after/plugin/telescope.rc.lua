local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions
local z_utils = require("telescope._extensions.zoxide.utils")

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["N"] = fb_actions.create,
          ["h"] = fb_actions.goto_parent_dir,
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
    zoxide = {
      prompt_title = "[ Cd in directory (recentcy) ]",
      mappings = {
        default = {
          after_action = function(selection)
            print("Update to (" .. selection.z_score .. ") " .. selection.path)
          end
        },
        ["<C-s>"] = {
          before_action = function(selection) print("before C-s") end,
          action = function(selection)
            vim.cmd("edit " .. selection.path)
          end
        },
        -- Opens the selected entry in a new split
        ["<C-q>"] = { action = z_utils.create_basic_command("split") },
      },
    },
    project = {
      prompt_title = "cd to Project root",
      base_dirs = {
        '~/discord/discord',
        '~/discord/discord/discord_api',
        '~/discord/discord/discord_app',
        '~/.vim',
        '~/.config/nvim',
        '~/dotfiles',
        '~/terminal'
      },
      hidden_files = true,
      sync_with_nvim_tree = true,
    }
  },
}

telescope.load_extension("file_browser")
telescope.load_extension("zoxide")
telescope.load_extension("project")

vim.keymap.set('n', '<tab>',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)
vim.keymap.set('n', '<space>r', function()
  builtin.live_grep()
end)
vim.keymap.set('n', '<space>o', function()
  builtin.buffers()
end)
vim.keymap.set('n', '<space>h', function()
  builtin.oldfiles()
end)
vim.keymap.set('n', '<space>t', function()
  builtin.help_tags()
end)
vim.keymap.set('n', ',;', function()
  builtin.resume()
end)
vim.keymap.set('n', ';e', function()
  builtin.diagnostics()
end)
vim.keymap.set("n", "sf", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end)
vim.keymap.set("n", "<space>j", telescope.extensions.zoxide.list)
vim.keymap.set("n", "<space>p", ":lua require'telescope'.extensions.project.project{}<CR>")
