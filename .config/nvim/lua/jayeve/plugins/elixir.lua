-- import elixir plugin safely
local setup, elixir = pcall(require, "elixir")
if not setup then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- enable elixir
elixir.setup()
