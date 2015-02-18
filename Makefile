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

development:
	@$(BIN)/watchify \
		-v \
		-g coffeeify \
		--extension=".coffee" \
		--outfile kd.js \
		--standalone kd \
		--debug \
		lib/index.coffee

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

