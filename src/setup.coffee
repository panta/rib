# -----------------------------------------------------------------------
#   Setup global object and module
# -----------------------------------------------------------------------

# global object
# (see http://stackoverflow.com/questions/4214731/coffeescript-global-variables)
root = exports ? this

# in browser?
if window?
  module ?= {}
  root.mixins = module
else
  module = root
