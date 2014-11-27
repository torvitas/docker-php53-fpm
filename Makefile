-include make.d/*

build:
	docker build -t $(DOCKERPREFIX)php53-fpm .

pull:
	docker pull torvitas/php53-fpm 

install:
	sudo cp systemd/docker-php53-fpm.service.tmpl $(SYSTEMDSERVICEFOLDER)$(NAMESPACE)-php53-fpm.service
	sudo cp -r systemd/docker-php53-fpm.service.d $(SYSTEMDSERVICEFOLDER)
	sudo sed -i s/$(DOCKERNAMESPACEPLACEHOLDER)/$(DOCKERNAMESPACE)/g $(SYSTEMDSERVICEFOLDER)$(NAMESPACE)-php53-fpm.service
	sudo sed -i s/$(NAMESPACEPLACEHOLDER)/$(NAMESPACE)/g $(SYSTEMDSERVICEFOLDER)$(NAMESPACE)-php53-fpm.service
	cd $(SYSTEMDSERVICEFOLDER)$(NAMESPACE)-php53-fpm.service.d/ && sudo ln -s ../$(SYSTEMDSERVICEFOLDER)$(NAMESPACE)-php-fpm.service.d/EnvironmentFile
	sudo sed -i s/LINKSTO=/LINKSTO=--link\ $(NAMESPACE)-php53-fpm:fpm53\ /g $(SYSTEMDSERVICEFOLDER)$(NAMESPACE)-nginx.service.d/EnvironmentFile
	sudo systemctl enable $(NAMESPACE)-php53-fpm.service

run:
	sudo systemctl start $(NAMESPACE)-php53-fpm

systemd-service-folder:
	sudo mkdir -p $(SYSTEMDSERVICEFOLDER)

uninstall:
	-sudo systemctl stop $(NAMESPACE)-php53-fpm
	-sudo systemctl disable $(NAMESPACE)-php53-fpm
	-docker stop $(NAMESPACE)-php53-fpm
	-docker rm $(NAMESPACE)-php53-fpm
	-cd $(SYSTEMDSERVICEFOLDER); sudo rm -r $(NAMESPACE)-php53-fpm.service*
	sudo sed -i s/--link\ $(NAMESPACE)-php53-fpm:fpm53\ //g $(SYSTEMDSERVICEFOLDER)$(NAMESPACE)-nginx.service.d/EnvironmentFile
