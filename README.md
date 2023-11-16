# lua-eww
> tldr: lua-eww is simple framework for creating your widgets in [eww](https://github.com/elkowar/eww) using lua.
> To be clear its not fully lua based you still have to define windows in your `eww.yuck`

### demo
simple demo listing your home dir with ability to open files see `/lua/widgets/tmp.lua` and delete when you get the gist of things

<img src="https://raw.githubusercontent.com/Horryportier/lua-eww/main/demo/home_dir.png" width=10% height=10%>


## Installation 
```
git clone https://github.com/Horryportier/lua-eww ~/.config/eww
or
git clone https://github.com/Horryportier/lua-eww ~/YOUR/PATH
```

## How it works 
lua-eww uses ***literal*** widget as its basis. You define defpoll variable whitch will ask lua for widget 
and will recive string formated as widget that will be used by literal in your window. 

lua-eww generates all the widgets by applying metatable that implemets `__tostring` function.
TO make new widget use `make new name=<name_of_widget>` to create any type 
of building blocks of your widget use 
```lua 
local foo = F.as_widget({ 
    class  = "some-class"
    children = { child1, cihld2 } 
}, F.BOX)
```
*children* have to be other tables that implemnt `as_widget`. 
If you need to pass only text then use `content` param



> at this moment there is i thing a bug that couses to all of your defpoll 
> values to not show if they are not used in `eww.yuck` when rendering `literals`.
> this means you need to have dummy widget that holds all the values but you can hide it quite easily.   

### requirements 
- lua (there is no lua libralies to worry about)
- eww 
- make

## Contribution 
Of course  you can just make an issue of anything you want to see whith in this tool or any bugs you see. 

