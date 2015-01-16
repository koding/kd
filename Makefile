BIN=./node_modules/.bin

dist: clean js css
	@mkdir -p dist
	@mv kd.* dist

js:
	@$(BIN)/browserify \
		--transform coffeeify \
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

clean:
	@rm -fr dist