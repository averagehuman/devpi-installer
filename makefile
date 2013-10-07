
#SHELL=/bin/bash

deploy:
	@if [ "${host}" != "" ]; then sed -i -e "s/host\s*=.*/host=${host}/" base.cfg; fi
	@if [ "${port}" != "" ]; then sed -i -e "s/port\s*=.*/port=${port}/" base.cfg; fi
	@if [ "${outside_url}" != "" ]; then sed -i -e "s/outside_url\s*=.*/outside_url=${outside_url}/" base.cfg; fi
	@if [ "${bottleserver}" != "" ]; then sed -i -e "s/bottleserver\s*=.*/bottleserver=${bottleserver}/" base.cfg; fi
	@if [ "${debug}" != "" ]; then sed -i -e "s/debug\s*=.*/debug=${debug}/" base.cfg; fi
	@if [ "${refresh}" != "" ]; then sed -i -e "s/refresh\s*=.*/refresh=${refresh}/" base.cfg; fi
	@if [ "${bypass_cdn}" != "" ]; then sed -i -e "s/bypass_cdn\s*=.*/bypass_cdn=${bypass_cdn}/" base.cfg; fi
	@if [ "${secretfile}" != "" ]; then sed -i -e "s/secretfile\s*=.*/secretfile=${secretfile}/" base.cfg; fi
	@if [ "${serverdir}" != "" ]; then sed -i -e "s/serverdir\s*=.*/serverdir=${serverdir}/" base.cfg; fi
	@if [ ! -e .installed.cfg ]; then \
		# if we're in a virtualenv, use the associated python, else use the system python \
		d=$$(dirname $$(pwd)); \
		py="python"; \
		until [ "$$d" = "/" ]; do \
			if [ -e "$$d/bin/python" ]; then \
				py="$$d/bin/python"; \
				break; \
			fi; \
		d=$$(dirname $$d); \
		done; \
		echo "$$py"; \
		$$py bootstrap.py; \
	fi;
	@./bin/buildout

supervisord:
	@if [ ! -e run/supervisord.pid ] || [ $$(kill -0 $$(cat run/supervisord.pid)) ]; then ./bin/supervisord; fi

status: supervisord
	@./bin/supervisorctl status

start: supervisord
	@./bin/supervisorctl start all

stop: supervisord
	@./bin/supervisorctl stop all


