default: compile

compile:
	mkdir -p build

dist: compile
	mkdir -p dist

clean:
	rm -rf build
	rm -rf dist

.PHONY: default compile dist clean