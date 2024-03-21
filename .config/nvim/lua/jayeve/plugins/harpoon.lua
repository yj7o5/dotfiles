local status, harpoon = pcall(require, "harpoon")
if not status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

local harpoon_ui_status, harpoon_ui = pcall(require, "harpoon.ui")
if not harpoon_ui_status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load harpoon.ui")
	return
end

local harpoon_mark_status, harpoon_mark = pcall(require, "harpoon.mark")
if not harpoon_mark_status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load harpoon.mark")
	return
end

local telescope_status, telescope = pcall(require, "telescope")
if not telescope_status then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load telescope")
	return
end

harpoon.setup()
telescope.load_extension("harpoon")
