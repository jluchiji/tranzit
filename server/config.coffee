# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #
fs   = require('fs')
path = require('path')
YAML = require('yamljs')


# Config file cache
cache = { }

# This file is where we load configuration
module.exports = (filename, forceLoad = no) ->

  # Check if already cached
  if cache[filename] and not forceLoad
    return cache[filename]

  # Resolve relative paths and load config file content
  filepath = path.resolve(path.join(__dirname, 'config'), filename)
  content = fs.readFileSync filepath, 'utf8'

  # Parse & Cache
  content = YAML.parse content
  cache[filename] = content

  # Return
  return content
