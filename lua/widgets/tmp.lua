F = require("../lua/framework")
M = {}


function Split(s, delimiter)
	local result = {};
	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match);
	end
	return result;
end

local function full_link(link)
	local l = io.popen("readlink -f " .. link, "r")
	if l == nil then return nil end
	return l:read("*a")
end

-- this function generates button widget for every file/dir in your home dir
local function display_files(folder)
	local cmd = io.popen("ls " .. folder)
	if cmd == nil then return nil end
	local files = Split(cmd:read("a"), '\n')
	local button_box = F.as_widget({
		orientation = F.VERTICAL,
		space_evenly = false,
		spacing = 2,
		halign = "end",
		valign = "end",
		children = {}
	}, F.BOX)
	for _, value in ipairs(files) do
		if value ~= "" then
			table.insert(button_box.children,
				F.as_widget({
					-- you can give every widget class 
					class = "tmp-button",
					content = value,
					-- you can create command by using make or,
					-- create script and point to it or,
					-- just write cmd but that may couse problems if there are 
					-- characters like " or ' which may not be parsed by eww correctly 
					onclick = string.format("make tmp_cmd path=%s val=%s",folder, value),
				}, F.BUTTON)
			)
		end
	end
	return button_box
end

-- main function for our tmp widget you can pass arguments in your's vars.yuck in that format -> name:value 
local tmp_widget = function (t)
return F.as_widget({
	class = "tmp-box",
	orientation = F.VERTICAL,
	halign = "end",
	valign = "end",
	space_evenly = false,
	children = {
		F.label(full_link(t.path)),
		display_files(full_link(t.path))
	}
}, F.BOX)
end

M.widget = tmp_widget
return M
