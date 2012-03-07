# -----------------------------------------------------------------------
# Module - class mixins as described in
#   http://arcturo.github.com/library/coffeescript/03_classes.html
#
# see also:
#   https://github.com/jashkenas/coffee-script/issues/452
# -----------------------------------------------------------------------

moduleKeywords = ['class', 'extended', 'included', '__name__', '__mixin__', '__mixins__', '__extends__']

class Module
  @include: (obj, name = null) ->
    # Here `this` (@) is the class being extended
    # and `obj` is the mixin
    throw('include(obj) requires obj') unless obj
    name = name ? obj.__name__
    obj.__name__ = name
    if name
      obj.__name__ = name
    obj.__mixin__ = obj
    @.__mixins__ ?= []
    @.__mixins__.push(obj)
    obj.__extends__ ?= []
    obj.__extends__.push(@)
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      @::[key] = value
    if obj.class
      if name
        obj.class.__name__ = name
      obj.class.__mixin__ = obj
      for key, value of obj.class when key not in moduleKeywords
        if typeof value == "function"
          # let's wrap the callable `value` passing the mixin as `this`
          # NOTE: we make a local copy of `value` into `_value` to
          #       capture the value of `value` in this exact moment :)
          _value = value
          wrapper = (args...) =>
            #dbg("calling class method #{_value} (this: ", obj, ")")
            _value.apply(@, args)
          obj.class[key] = wrapper
          @[key] = wrapper
        else
          @[key] = value

    if name?
      @[name] = obj
      @::[name] = obj

    obj.included?.apply(@)
    this

  constructor: ->
    @init?(arguments...)

module.Module = Module

msg = (args...) ->
  console?.log?(args...)

MixinA =
  __name__: "MixinA"

  simpleMethodFromA: ->
    "simple_A"

  methodFromA: ->
    msg("methodFromA called")
    @getDoubleA()

  greet: ->
    msg("MixinA greet")
    msg(@)
    @a *= 2
    msg("hello #{@a}")

  class:
    ClassMethod: ->
      msg("class method A")
      msg(@)

MixinB =
  __name__: "MixinB"

  simpleMethodFromB: ->
    "simple_B"

  methodFromB: ->
    msg("methodFromB called")
    @getHalfA()

  greet: ->
    msg("MixinB greet")
    msg(@)
    @a += 1
    msg("hola! #{@a}")

  class:
    ClassMethod: ->
      msg("class method B")
      msg(@)
    GetThis: ->
      msg(@)
      @

class SimpleClass extends Module
  @include MixinA
  @include MixinB

  constructor: ->
    msg("constructor")
    @a = 4
    msg(@)

  getDoubleA: ->
    @a * 2

  getHalfA: ->
    @a / 2

  testInherited1: ->
    msg("testInherited1")
    r = @methodFromA()
    assert r == 8
    r

  testInherited2: ->
    msg("testInherited2")
    r = @methodFromB()
    assert r == 2
    r

  testInherited: ->
    msg("testInherited")
    @methodFromA()
    @methodFromB()

  callGetThis: ->
    @MixinB.class.GetThis()

  greet: ->
    msg("SimpleClass greet")
    @MixinA.greet.apply(@)
    @MixinB.greet.apply(@)
    @MixinA.class.ClassMethod()
    @MixinB.class.ClassMethod()
    #@MixinA.class.ClassMethod.apply(MixinA)
    #@MixinB.class.ClassMethod.apply(MixinB)

module.SimpleClass = SimpleClass

#myInstance = new SimpleClass()
#myInstance.greet()
