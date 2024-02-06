get: 
	@lua ./eww.lua $(name) $(args)
open_dev:
	@eww open $(win) -c .
open:
	@eww open $(win) 
kill: 
	@eww kill
kill_dev: 
	@eww kill -c .
daemon:
	@eww daemon
daemon_dev:
	@eww daemon -c .
tmp_cmd:
	@open $(path)/$(val)
new:
	@./new.sh $(name)
