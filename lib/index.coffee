path    = require 'path'
glob    = require 'glob'
_       = require 'lodash'
indx    = require 'indx'

exports.supports = supports = (name) ->
  name = adapter_to_name(name)
  !!glob.sync("#{path.join(__dirname, 'adapters', name)}.*").length

exports.load = (name, custom_path, engineName) ->
  name = adapter_to_name(name)
  return new (require(path.join(__dirname, 'adapters', name)))(engineName, custom_path)

exports.all = ->
  indx(path.join(__dirname, 'adapters'))


# Responsible for mapping between adapters where the language name
# does not match the node module name. direction can be "left" or "right",
# "left" being lang name -> adapter name and right being the opposite.
#
abstract_mapper = (name, direction) ->
  name_maps = [
    ['markdown', 'marked']
    ['minify-js', 'uglify-js']
    ['minify-css', 'clean-css']
    ['minify-html', 'html-minifier']
    ['mustache', 'hogan.js']
    ['scss', 'node-sass']
    ['haml', 'hamljs']
    ['escape-html', 'he']
  ]

  res = null
  name_maps.forEach (n) ->
    if direction is 'left' and n[0] is name then res = n[1]
    if direction is 'right' and n[1] is name then res = n[0]

  return res or name

name_to_adapter = (name) ->
  abstract_mapper(name, 'left')

adapter_to_name = (name) ->
  abstract_mapper(name, 'right')
