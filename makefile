
#SHELL=/bin/bash


setup:
	@mkdir -p etc/buildout

install:
	@if [ "${host}" != "" ]; then sed -i -e "s/host\s*=.*/host=${host}/" base.cfg; fi
	@if [ "${port}" != "" ]; then sed -i -e "s/port\s*=.*/port=${port}/" base.cfg; fi
	@if [ "${outside_url}" != "" ]; then sed -i -e "s/outside_url\s*=.*/outside_url=${outside_url}/" base.cfg; fi
	@if [ "${debug}" != "" ]; then sed -i -e "s/debug\s*=.*/debug=${debug}/" base.cfg; fi
	@if [ "${refresh}" != "" ]; then sed -i -e "s/refresh\s*=.*/refresh=${refresh}/" base.cfg; fi
	@if [ "${bypass_cdn}" != "" ]; then sed -i -e "s/bypass_cdn\s*=.*/bypass_cdn=${bypass_cdn}/" base.cfg; fi
	@if [ "${secretfile}" != "" ]; then sed -i -e "s/secretfile\s*=.*/secretfile=${secretfile}/" base.cfg; fi
	@if [ "${serverdir}" != "" ]; then sed -i -e "s/serverdir\s*=.*/serverdir=${serverdir}/" base.cfg; fi
	@if [ "${aliasdir}" != "" ]; then sed -i -e "s/aliasdir\s*=.*/aliasdir=${aliasdir}/" base.cfg; fi
	@if [ ! -e .installed.cfg ]; then \
		d=$$(dirname $$(pwd)); \
		py="python"; \
		until [ "$$d" = "/" ]; do \
			if [ -e "$$d/bin/python" ]; then \
				py="$$d/bin/python"; \
				break; \
			fi; \
		d=$$(dirname $$d); \
		done; \
		echo " Bootstrapping with $$py"; \
		$$py bootstrap.py; \
	fi;
	@./bin/buildout
	@cp etc/supervisor.conf /etc/supervisor/conf.d/devpi-server.conf

stop:
	@supervisorctl stop devpi-server

start:
	@supervisorctl start devpi-server

reinstall: stop install start


