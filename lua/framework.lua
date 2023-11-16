M = {
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
	VERTICAL="v",
	HORIZONTAL="h",
}



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
function M.as_widget(table, widget_name)
	table.widget_name = widget_name
	return setmetatable(table, Widget_meta)
end

--- simply prints widget
---@param widget table
local function send_widget(widget)
	print(widget)
end

NO_WIDGET_OF_THAT_NAME = M.as_widget({ text = "no widget of that name" }, M.LABEL)
NO_WIDGET_PROVIDED = M.as_widget({ text = "no widget provided" }, M.LABEL)

--- takes first cli arg as widget name and tries to find in table of provided widgets
---@param widgets table
---@return nil
function M.from_args(widgets)
	local get = arg[1];
	if get == nil then
		send_widget(NO_WIDGET_PROVIDED)
		return nil
	end
	local widget = widgets[get]
	if widget ~= nil then
		send_widget(widget)
	else
		send_widget(NO_WIDGET_OF_THAT_NAME)
	end
end

return M
