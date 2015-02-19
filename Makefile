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
		var w = chokidar.watch('./lib/**/*.coffee', {  persistent: true  }); \
		w.on('change', function (path) { \
			console.log('changed ' + path); \
			child_process.exec('make build/' + path.replace('coffee', 'js'), \
				function (err, stdout) { \
					if (err) return console.log(err); \
					process.stdout.write(stdout); \
				}); \
			});"

example: watch-example
	@$(BIN)/serve

watch-example: 
	@$(BIN)/watchify \
		-v \
		-g coffeeify \
		--extension=".coffee" \
		--outfile example/bundle.js \
		--debug \
		example/index.js &

js:
	@$(BIN)/browserify \
		-g coffeeify \
		--extension=".coffee" \
		--outfile kd.js \
		--standalone kd \
		lib/index.coffee
	@$(BIN)/uglifyjs kd.js \
		--mangle -c hoist_vars=true,if_return=true \
		--screw-ie8 \
		-o kd.min.js \
		--source-map kd.min.map --source-map-include-sources

css:
	@$(BIN)/stylus \
		--include-css \
		--print \
		lib/styles/index.styl \
	| $(BIN)/cleancss \
		--s0 \
		--source-map \
		--output kd.css

clean: clean_dist
	@rm -fr build

clean_dist:
	@rm -fr dist

.PHONY: example
