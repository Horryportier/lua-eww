F = require("../lua/framework")
M = {}

local home_dir = F.as_widget({
	-- this way you can acces your eww values 
	text = "${home_dir}",
	-- you can use inline styling 
	style = "color: #DE6284; padding: 1em; border: dotted 0.1em #78646D; border-radius: 8px; margin-bottom: 1em;"
}, F.LABEL)

function Split(s, delimiter)
	local result = {};
	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match);
	end
	return result;
end

-- this function generates button widget for every file/dir in your home dir
local function display_files()
	local cmd = io.popen("ls $HOME")
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
					onclick = "make tmp_cmd val=" .. value,
				}, F.BUTTON)
			)
		end
	end
	return button_box
end

-- main box for our tmp widget
local tmp_widget = F.as_widget({
	class = "tmp-box",
	orientation = F.VERTICAL,
	halign = "end",
	valign = "end",
	space_evenly = false,
	children = {
		home_dir,
		display_files()
	}
}, F.BOX)

M.widget = tmp_widget
return M
