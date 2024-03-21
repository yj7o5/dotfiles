-- import gitlinker plugin safely
local setup, gitlinker = pcall(require, "gitlinker")
if not setup then
	local info = debug.getinfo(1, "S").short_src
	print(info, "failed to load")
	return
end

-- configure/enable gitlinker
gitlinker.setup({
	callbacks = {
		-- cloudflare
		["bitbucket.cfdata.org"] = function(url_data)
			local project = url_data.repo:sub(1, url_data.repo:find("/") - 1)
			local repo = url_data.repo:sub(url_data.repo:find("/") + 1)
			local url = "https://bitbucket.cfdata.org/projects/"
				.. project
				.. "/repos/"
				.. repo
				.. "/browse/"
				.. url_data.file
				.. "?at="
				.. url_data.rev
				.. "#"
				.. url_data.lstart
			if url_data.lend then
				url = url .. "-" .. url_data.lend
			end
			return url
		end,
	},
})
