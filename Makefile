get: 
	@lua eww.lua $(name)
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
	@open ~/$(val)
new:
	@./new.sh $(name)
