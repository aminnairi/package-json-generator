.PHONY: reactor build start install clean

install:
	docker-compose run --rm npm install

build:
	docker-compose run --rm sh rm -f ./docs/index.js
	docker-compose run --rm elm make --output docs/index.js --optimize src/Main.elm
	docker-compose run --rm node ./node_modules/.bin/uglifyjs ./docs/index.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | docker-compose run --rm node ./node_modules/.bin/uglifyjs --mangle --output ./docs/index.js

reactor:
	docker-compose run --rm --service-ports elm reactor

start:
	docker-compose run --rm --service-ports nginx

clean:
	docker-compose run --rm sh rm -rf elm-stuff .config .elm .npm node_modules .bash_history
