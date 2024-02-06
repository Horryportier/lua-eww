function Split(s, delimiter)
	local result = {};
	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match);
	end
	return result;
end

F = {
	COMBO_BOX_TEXT = "combo-box-text",
	EXPANDER = "expander",
	REVEALER = "revealer",
	CHECKBOX = "checkbox",
	COLOR_BUTTON = "color-button",
	COLOR_CHOOSER = "color-chooser",
	SCALE = "scale",
	PROGRESS = "progress",
	INPUT = "input",
	BUTTON = "button",
	IMAGE = "image",
	BOX = "box",
	OVERLAY = "overlay",
	CENTERBOX = "centerbox",
	SCROLL = "scroll",
	EVENTBOX = "eventbox",
	LABEL = "label",
	CALENDAR = "calendar",
	TRANSFORM = "transform",
	CIRCULAR_PROGRESS = "circular-progress",
	GRAPH = "graph",
	VERTICAL = "v",
	HORIZONTAL = "h",
	START = "start",
	END = "end",
}

Options_meta = {
	__add = function(a, b)
		local tmp = {}
		for key, value in pairs(a) do
			tmp[key] = value
		end
		for key, value in pairs(b) do
			tmp[key] = value
		end
		return tmp
	end
}



--- turns table into options table that implements __add method which takes `a, b` table
--- and adds or updateds keys in `a` with values of `b`  overithing `a` keys if exist.
--- ex. local box_opts = F.as_option_table { space_evenly = false, spacing = 4 };
--	F.box_opts({...}, box_opts + { class = "foo", spacing = 8} )
---@param t table
---@return table Options_meta
function F.as_option_table(t)
	setmetatable(t, Options_meta)
	return t
end

---adds options to table
---@param table any
---@param opts table
---@return table
local function fill_opts(table, opts)
	for key, value in pairs(opts) do
		table[key] = value
	end
	return table
end


--- changes any  `_` to  `-` becouse `-` can't be used in lua as value identifier
---@param key string
---@return string
local function correct_key(key)
	local replaced = key:gsub("_", "-")
	return replaced
end

--- foramts values of your table into eww params
---@param key any
---@param value any
---@return string
local function format_param(key, value)
	if type(key) == 'boolean' then return string.format(":%s %s", correct_key(key), value) end
	if type(key) == 'number' then return string.format(":%s %s", correct_key(key), value) end
	if key == 'children' then return "" end
	if key == 'style' then return string.format(":%s '%s'", key, value) end
	if key == 'content' then return "" end
	if key == 'widget_name' then return "" end
	if type(key) == 'string' then return string.format(":%s '%s'", correct_key(key), value) end
	if type(key) == 'function' then return "" end
	return ""
end

--- formats_table  is used for formating children of the widget
---@param table any
---@return string
local function format_table(table)
	local tmp = ""
	for _, value in ipairs(table) do
		tmp = tmp .. " " .. string.format("%s\n", value)
	end
	return tmp
end


Widget_meta = {
	--- this function will format table into widget that can be used as literal in your widget
	---@param self table
	__tostring = function(self)
		local format = "(%s %s)"
		local params = ""
		local children = {}
		for key, value in pairs(self) do
			if key == 'children' then
				children = value
			end
			params = params .. " " .. format_param(key, value)
		end
		if self.content ~= nil then
			params = params .. " '" .. self.content .. "'"
		end
		params = params .. " " .. format_table(children)
		return string.format(format, self.widget_name, params)
	end
}

--- takes tabele and widget type and applies Widget_meta metatable returnig table
---@param table table
---@param widget_name string
---@return table
function F.as_widget(table, widget_name)
	table.widget_name = widget_name
	return setmetatable(table, Widget_meta)
end

--- simply prints widget
---@param widget table
local function send_widget(widget)
	print(widget)
end

NO_WIDGET_OF_THAT_NAME = F.as_widget({ text = "no widget of that name" }, F.LABEL)
NO_WIDGET_PROVIDED = F.as_widget({ text = "no widget provided" }, F.LABEL)

--- takes first cli arg as widget name and tries to find in table of provided widgets
---@param widgets table
---@return nil
function F.from_args(widgets)
	local fun = arg[1];
	local get_args = function()
		local tmp = {}
		for index, value in ipairs(arg) do
			if index ~= 1 then
				local named = Split(value, ":")
				if #named == 2 then
					tmp[named[1]] = named[2]
				else
					table.insert(tmp, value)
				end
			end
		end
		return tmp
	end
	local args = get_args()
	local no_send = args["no_send"]

	if fun == nil then
		send_widget(NO_WIDGET_PROVIDED)
		return nil
	end
	local widget = widgets[fun]
	if widget ~= nil then
		if no_send == nil or no_send == false then
			send_widget(widget(args))
		else
			widget(args)
		end
	else
		send_widget(NO_WIDGET_OF_THAT_NAME)
	end
end

function F.box(children, opts)
	opts = opts or {}
	local box = F.as_widget({
		children = {}
	}, F.BOX)
	for _, value in pairs(children) do
		table.insert(box.children, value)
	end
	fill_opts(box, opts)
	return box
end

function F.label(text, opts)
	opts = opts or {}
	local label = F.as_widget({
		text = text
	}, F.LABEL)
	return fill_opts(label, opts)
end

function F.image(path, size, opts)
	opts = opts or {}
	local image = F.as_widget({
		path = path,
		image_width = size,
	}, F.IMAGE)
	return fill_opts(image, opts)
end

return F
