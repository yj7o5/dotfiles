require('jayeve.base')
require('jayeve.highlights')
require('jayeve.maps')
require('jayeve.plugins')

local has = vim.fn.has
local is_mac = has "macunix"
local is_win = has "win32"

if is_mac then
  require('jayeve.macos')
end
if is_win then
  require('jayeve.windows')
end
