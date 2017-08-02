BIN=./node_modules/.bin
SRC=$(shell find lib -name "*.coffee")
TARGETS=$(patsubst %.coffee,build/%.js,$(SRC))

all: clean prepublish dist

dist: clean_dist js css
	@mkdir -p dist
	@mv kd.* dist

prepublish: $(TARGETS)

build/%.js: %.coffee
	@mkdir -p $(@D)
	@$(BIN)/coffee -p -b $< >$@
	@echo 'written $@'

development-dist:
	@$(BIN)/watchify \
		-v \
		-g coffeeify \
		--extension=".coffee" \
		--outfile kd.js \
		--standalone kd \
		--debug \
		lib/index.coffee

development: $(TARGETS)
	@echo "watching kd.js/lib"
	@node -e "\
		var chokidar = require('chokidar'); \
		var child_process = require('child_process'); \
		var rimraf = require('rimraf'); \
		var w = chokidar.watch('./lib/**/*.coffee', {  persistent: true  }); \
		w.on('change', function (path) { \
			console.log('changed ' + path); \
			rimraf.sync('./build/' + path.replace('coffee', 'js')); \
			child_process.exec('make build/' + path.replace('coffee', 'js'), \
				function (err, stdout) { \
					if (err) return console.log(err); \
					process.stdout.write(stdout); \
				}); \
			});"

example: dist
	@echo ' - Running example server...'
	@cp ./dist/kd.js  examples/
	@cp ./dist/kd.css examples/
	@$(BIN)/serve examples -o

js:
	@echo ' - Browserify and Uglify...'
	@$(BIN)/browserify \
		-g coffeeify \
		--extension=".coffee" \
		--outfile kd.js \
		--standalone kd \
		index.coffee
	@$(BIN)/uglifyjs kd.js \
		--mangle -c hoist_vars=true,if_return=true \
		--screw-ie8 \
		-o kd.min.js

css:
	@echo ' - Stylus and clean-css...'
	@$(BIN)/stylus \
		--include-css \
		--print \
		lib/styles/index.styl \
	| $(BIN)/cleancss \
		-O0 \
		-o kd.css

clean: clean_dist
	@rm -fr build

clean_dist:
	@echo ' - Cleanup...'
	@rm -fr dist
	@rm -f examples/kd.*

.PHONY: example dist
