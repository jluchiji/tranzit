# Main build script
gulp      = require 'gulp'
load      = require 'require-dir'
_         = require 'underscore'

# Enable coffee-script compiler
coffee    = require 'coffee-script/register'

# CLI Arguments
argv      = require('yargs')
  .alias('t', 'target')
  .default('t', 'development')
  .argv

# Config Object
config    = require('./targets.json')
config    = _.extend config.default, config[argv.target]

# Load tasks
register(gulp, config) for name, register of load('gulp')
