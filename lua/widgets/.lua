F = require("../lua/framework")
F = {}

local label = F.as_widget({
	text = "basic template",
	style = "padding: 1em; border: dotted 0.1em; border-radius: 8px; margin-bottom: 1em;"
}, F.LABEL)

local widget = F.as_widget({
	orientation = F.VERTICAL,
	halign = "end",
	valign = "end",
	space_evenly = false,
	children = {
		 label,
	}
}, F.BOX)

F.tmp = widget
return F
