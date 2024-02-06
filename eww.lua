F = require("../lua/framework")
-- place your widgets in this key value should be the same as value in vars.yuck 
-- (defpoll tmp :interval "100s" `make get name=tmp`) == tmp=tmp_widget 
local test = F.label("test")
WIDGETS = {
	-- see /lua/widgets/tmp.lua to undersand how to build your own widgets 
	-- when you undrestand you may delete everything related with tmp widget
	tmp = require("/lua/widgets/tmp").widget,
}

F.from_args(WIDGETS)
