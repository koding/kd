#!/bin/bash
echo "require './lib.includes.coffee'"
echo "utils      = require './core/utils.coffee'"

echo "KD         = require './core/kd.coffee'"
echo "KD.dom     = require './core/kd.dom.js'"

echo "KD.classes = {}"

grep "module.exports\s*=\s*class " * -R | sort | awk -F':' '{ print $1,$2 }' | awk '{ print "KD.classes."$5,"= require \"./"$1"\" " }'

echo "KD.exportKDFramework()"
