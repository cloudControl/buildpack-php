all: pinky trinity

pinky-prepare:
	docker build -t pinkyphpbuild:latest Pinky

pinky-build:
	docker run -e "STACK=pinky" -v $(shell pwd):/vagrant -ti pinkyphpbuild:latest /vagrant/php-build.sh $(version)

pinky: pinky-prepare pinky-build

trinity-prepare:
	docker build -t trinityphpbuild:latest Trinity

trinity-build:
	docker run -e "STACK=trinity" -v $(shell pwd):/vagrant -ti trinityphpbuild:latest /vagrant/php-build.sh $(version)

trinity: trinity-prepare trinity-build

clean:
	rm -rf dist/*
