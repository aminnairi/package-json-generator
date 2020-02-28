# Prevent these commands to be treated as files/folders
.PHONY: reactor build start install clean deploy

# Install the Node.js dependencies
install:
	docker-compose run --rm npm install

# Build the Web application
build:
	docker-compose run --rm sh rm -f ./docs/index.js
	docker-compose run --rm elm make --output docs/index.js --optimize src/Main.elm
	docker-compose run --rm node ./node_modules/.bin/uglifyjs ./docs/index.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | docker-compose run --rm node ./node_modules/.bin/uglifyjs --mangle --output ./docs/index.js

# Serve the project using Elm's built-in Web server
reactor:
	docker-compose run --rm --service-ports elm reactor

# Start the NGINX server
start:
	docker-compose run --rm --service-ports nginx

# Remove the artifacts
clean:
	docker-compose run --rm sh rm -rf elm-stuff .config .elm .npm node_modules .bash_history

# Deploy the Web application to Zeit's servers
deploy:
	docker-compose run --rm node ./node_modules/.bin/now ./docs
