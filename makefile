
PYTHON=python

deploy:
	@if [ ! -e .installed.cfg ]; then ${PYTHON} bootstrap.py; fi
	@./bin/buildout

supervisord:
	@if [ ! -e run/supervisord.pid ] || [ $$(kill -0 $$(cat run/supervisord.pid)) ]; then ./bin/supervisord; fi

status: supervisord
	@./bin/supervisorctl status

start: supervisord
	@./bin/supervisorctl start all

stop: supervisord
	@./bin/supervisorctl stop all


