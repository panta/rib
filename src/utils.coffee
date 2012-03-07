# -----------------------------------------------------------------------
#   Assertions
# -----------------------------------------------------------------------

class AssertException
  constructor: (message, args...) ->
    @message = message
    @args = args

  toString: ->
    "AssertException: #{@message}"

assert = (exp, message = "Assertion failed") ->
  if not exp
    throw new AssertException(message)

module.AssertException = AssertException
module.assert = assert

# -----------------------------------------------------------------------
#   Namespaces
# -----------------------------------------------------------------------

# namespaces
#   see https://github.com/jashkenas/coffee-script/wiki/FAQ
#
# Usage:
#   namespace 'Hello.World', (exports) ->
#     # `exports` is where you attach namespace members
#     exports.hi = -> console.log 'Hi World!'
#   namespace 'Say.Hello', (exports, top) ->
#     # `top` is a reference to the main namespace
#     exports.fn = -> top.Hello.World.hi()
#   Say.Hello.fn()  # prints 'Hi World!'
namespace = (target, name, block) ->
  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, top

module.namespace = namespace

# -----------------------------------------------------------------------
#   Debug messages
# -----------------------------------------------------------------------

dbg = (args...) ->
  args.unshift("[DEBUG]")
  console?.log?(args...)
module.dbg = dbg

# -----------------------------------------------------------------------
#   Simple UID - Unique ID
# -----------------------------------------------------------------------

UID = (prefix) ->
  _.uniqueId(prefix)

module.UID = UID
