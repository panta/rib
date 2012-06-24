# Cakefile
# rib library
# Copyright (C) 2012 Marco Pantaleoni. All rights reserved.

util           = require('util')
util = require('util')
fs             = require('fs')
path           = require('path')
{spawn, exec}  = require('child_process')
CoffeeScript   = require('coffee-script')
uglify         = require('uglify-js')

srcdir   = 'src/'
srcfiles = ['src/setup.coffee', 'src/utils.coffee', 'src/mixins.coffee']
builddir = 'build'
distdir  = 'dist'

option '-B', '--builddir [DIR]', "directory for intermediate build products (default '#{builddir}')"
option '-o', '--output [DIR]', "directory for distribution files (default '#{distdir}')"
option '-w', '--watch',  'continue to watch the files and rebuild them when they change'
option '-s', '--coverage', 'run jscoverage during tests and report coverage (test task only)'
option '-v', '--verbose', 'Use jasmine verbose mode'

handleError = (err) ->
  if err
    console.log "\n\033[1;36m=>\033[1;37m Remember that you need: coffee-script@1.1.2 and jasmine-node@1.0.21\033[0;37m\n"
    console.log err.stack

makedir = (dir) ->
  try
    fs.mkdirSync dir, 0777
  catch e
    null

getpaths = (opts) ->
  buildpath = opts.builddir or builddir
  buildpath = path.join(__dirname, buildpath) unless buildpath[0] = '/'
  outpath = opts.output or distdir
  outpath = path.join(__dirname, outpath) unless outpath[0] = '/'
  {
    src: srcdir
    build: buildpath
    dist: outpath
  }

task 'build', 'Rebuild all public resources', ->
  invoke('build:js')

task 'clean', 'Remove everything that was built', ->
  invoke('clean:js')

task 'build:js', 'Build library into javascript', (opts) ->
  paths = getpaths opts

  makedir paths.build
  build_coffee_dst = path.join(paths.build, 'rib.coffee')
  code = []
  srcfiles.forEach (file) ->
    console.log("reading #{file}")
    code.push(fs.readFileSync(file, 'utf8'))
  fs.writeFileSync(build_coffee_dst, code.join("\n"), 'utf8')

  dist_js_dst = path.join(paths.dist, 'rib.js')
  dist_minjs_dst = path.join(paths.dist, 'rib.min.js')
  console.log "Building #{dist_js_dst}"
  fs.writeFileSync(dist_js_dst, CoffeeScript.compile(fs.readFileSync(build_coffee_dst, 'utf8')))
  console.log "Building #{dist_minjs_dst}"
  jscode = fs.readFileSync(dist_js_dst, 'utf8')
  uglify_options = {
    strict_semicolons: true
    mangle_options: {except: ['$super']}
    gen_options: {ascii_only: true}
  }
  minified_jscode = uglify(jscode, uglify_options)
  fs.writeFileSync(dist_minjs_dst, minified_jscode, 'utf8')
  console.log 'Done.'

task 'clean:js', 'Remove built javascript', (opts) ->
  paths = getpaths opts
  try
    for file in fs.readdirSync paths.build
      filepath = path.join(paths.build, file)
      fs.unlink(filepath)
    fs.rmdir(paths.build)
  catch e
    null
  console.log 'Done.'

task 'test', 'Test the app', (options) ->
  jasmine = require 'jasmine-node'
  specFolder = path.join(__dirname, 'spec')
  console.log "\n\033[1;36m=>\033[1;37m Running spec from #{specFolder}\033[0;37m\n"

  isVerbose = options.verbose
  showColors = true
  extentions = 'js|coffee'

  jasmine.loadHelpersInFolder(specFolder, new RegExp("[-_]helper\.(js|coffee)$"))
  jasmine.executeSpecsInFolder specFolder, (runner, log) ->
    util.print('\n');
    if runner.results().failedCount is 0
      process.exit(0);
    else
      process.exit(1);
  , isVerbose, showColors, false, false, new RegExp(".spec\\.(" + extentions + ")$", 'i')
