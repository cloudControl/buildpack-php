all: pinky trinity

pinky-prepare:
	docker build -t pinkyphpbuild:latest Pinky

pinky-build:
	docker run -e "STACK=pinky" -v $(shell pwd):/build -ti pinkyphpbuild:latest /build/php-build.sh $(version)

pinky: pinky-prepare pinky-build

trinity-prepare:
	docker build -t trinityphpbuild:latest Trinity

trinity-build:
	docker run -e "STACK=trinity" -v $(shell pwd):/build -ti trinityphpbuild:latest /build/php-build.sh $(version)

trinity: trinity-prepare trinity-build

clean:
	rm -rf dist/*
