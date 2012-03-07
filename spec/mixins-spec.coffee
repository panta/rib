rib = if require? then require("../dist/rib") else window.rib
util = if require? then require("util") else window.util?
sys = if require? then require("sys") else window.sys?

describe "stupid", ->
  it 'should pass this', ->
    expect(true).toEqual(true)

describe "mixins", ->
  it "tests basic mixin functionality", ->
    SimpleMixin =
      hello: ->
        "hello"
    class SimpleClass extends rib.Module
      @include SimpleMixin
    i = new SimpleClass()
    expect(typeof i.hello).toEqual("function")
    expect(i.hello()).toEqual("hello")

  it "tests mixin class attributes", ->
    SimpleMixin =
      class:
        classMethod: ->
          "classy"
    class SimpleClass extends rib.Module
      @include SimpleMixin
    i = new SimpleClass()
    expect(typeof SimpleClass.classMethod).toEqual("function")
    expect(SimpleClass.classMethod()).toEqual("classy")

  it "tests access of instance variable from mixin method", ->
    SimpleMixin =
      getInstanceValue: ->
        @value
    class SimpleClass extends rib.Module
      @include SimpleMixin
      constructor: ->
        @value = 5
    i = new SimpleClass()
    expect(typeof i.getInstanceValue).toEqual("function")
    expect(i.getInstanceValue()).toEqual(i.value)

  it "tests for `this` in mixin class methods, calling through mixin `class`", ->
    SimpleMixin =
      class:
        getMixinClassMethodThis: ->
          @
    class SimpleClass extends rib.Module
      @include SimpleMixin
    i = new SimpleClass()
    expect(typeof SimpleMixin.class.getMixinClassMethodThis).toEqual("function")
    expect(SimpleMixin.class.getMixinClassMethodThis()).toBe(SimpleClass)

  it "tests for `this` in mixin class methods, calling from class", ->
    SimpleMixin =
      class:
        getMixinClassMethodThis: ->
          @
    class SimpleClass extends rib.Module
      @include SimpleMixin
    i = new SimpleClass()
    expect(typeof SimpleClass.getMixinClassMethodThis).toEqual("function")
    expect(SimpleClass.getMixinClassMethodThis()).toBe(SimpleClass)

  it "tests access to class attributes from mixin class methods", ->
    SimpleMixin =
      class:
        classMethod: ->
          @classAttr
    class SimpleClass extends rib.Module
      @include SimpleMixin
      @classAttr = 5
    i = new SimpleClass()
    expect(typeof SimpleClass.classMethod).toEqual("function")
    expect(SimpleClass.classMethod()).toEqual(5)

  it "tests mixin initialization", ->
    SimpleMixin =
      init: ->
        @b = 10
    class SimpleClass extends rib.Module
      @include SimpleMixin
    i = new SimpleClass()
    expect(i.b).toEqual(10)

  it "tests calling mixin method from normal method", ->
    SimpleMixin =
      hello: ->
        "hello"
    class SimpleClass extends rib.Module
      @include SimpleMixin
      greet: ->
        @hello()
    i = new SimpleClass()
    expect(i.greet()).toEqual("hello")

  it "tests __name__, __mixin__, __mixins__ when not setting name", ->
    SimpleMixin =
      hello: ->
        "hello"
    class SimpleClass extends rib.Module
      @include SimpleMixin
    i = new SimpleClass()
    expect(SimpleMixin.__name__).toBeUndefined()
    expect(SimpleMixin.__mixin__).toBe(SimpleMixin)
    expect(SimpleClass.__mixins__).toContain(SimpleMixin)

  it "tests mixin __extends__", ->
    SimpleMixin =
      __name__: "SimpleMixin"
      hello: ->
        "hello"
    class SimpleClass extends rib.Module
      @include SimpleMixin
    class OtherClass extends rib.Module
      @include SimpleMixin
    i = new SimpleClass()
    expect(SimpleMixin.__extends__).toContain(SimpleClass)
    expect(SimpleMixin.__extends__).toContain(OtherClass)

  it "tests __name__, __mixin__, __mixins__ when using __name__", ->
    SimpleMixin =
      __name__: "SimpleMixin"
      hello: ->
        "hello"
    class SimpleClass extends rib.Module
      @include SimpleMixin
    i = new SimpleClass()
    expect(SimpleMixin.__name__).toEqual("SimpleMixin")
    expect(SimpleMixin.__mixin__).toBe(SimpleMixin)
    expect(SimpleClass.__mixins__).toContain(SimpleMixin)

  it "tests __name__, __mixin__, __mixins__ when using `name` argument", ->
    SimpleMixin =
      hello: ->
        "hello"
    class SimpleClass extends rib.Module
      @include SimpleMixin, "SimpleMixin"
    i = new SimpleClass()
    expect(SimpleMixin.__name__).toEqual("SimpleMixin")
    expect(SimpleMixin.__mixin__).toBe(SimpleMixin)
    expect(SimpleClass.__mixins__).toContain(SimpleMixin)

  it "tests __name__, __mixin__, __mixins__ when using __name__ for multiple mixins", ->
    MixinA =
      __name__: "MixinA"
      greet: ->
        "hello"
    MixinB =
      __name__: "MixinB"
      greet: ->
        "hola!"
    class SimpleClass extends rib.Module
      @include MixinA
      @include MixinB
    i = new SimpleClass()
    expect(MixinA.__name__).toEqual("MixinA")
    expect(MixinA.__mixin__).toBe(MixinA)
    expect(MixinB.__name__).toEqual("MixinB")
    expect(MixinB.__mixin__).toBe(MixinB)
    expect(SimpleClass.__mixins__).toContain(MixinA)
    expect(SimpleClass.__mixins__).toContain(MixinB)

  it "tests __name__, __mixin__, __mixins__ when using `name` argument for multiple mixins", ->
    MixinA =
      greet: ->
        "hello"
    MixinB =
      greet: ->
        "hola!"
    class SimpleClass extends rib.Module
      @include MixinA, "MixinA"
      @include MixinB, "MixinB"
    i = new SimpleClass()
    expect(MixinA.__name__).toEqual("MixinA")
    expect(MixinA.__mixin__).toBe(MixinA)
    expect(MixinB.__name__).toEqual("MixinB")
    expect(MixinB.__mixin__).toBe(MixinB)
    expect(SimpleClass.__mixins__).toContain(MixinA)
    expect(SimpleClass.__mixins__).toContain(MixinB)

  it "tests accessing the mixin using the name from a method when using multiple mixins", ->
    MixinA =
      greet: ->
        "hello"
    MixinB =
      greet: ->
        "hola!"
    class SimpleClass extends rib.Module
      @include MixinA, "MixinA"
      @include MixinB, "MixinB"
      getMixinA: ->
        @MixinA
      getMixinB: ->
        @MixinB
    i = new SimpleClass()
    expect(i.getMixinA()).toBe(MixinA)
    expect(i.getMixinB()).toBe(MixinB)

  it "tests disambiguating multiple mixins methods", ->
    MixinA =
      greet: ->
        "hello"
    MixinB =
      greet: ->
        "hola!"
    class SimpleClass extends rib.Module
      @include MixinA, "MixinA"
      @include MixinB, "MixinB"
      greet_A: ->
        @MixinA.greet.apply(@)
      greet_B: ->
        @MixinB.greet.apply(@)
    i = new SimpleClass()
    expect(i.greet_A()).toEqual("hello")
    expect(i.greet_B()).toEqual("hola!")

  it "tests disambiguating multiple mixins class methods", ->
    MixinA =
      greet: ->
        "hello"
      class:
        getLanguage: ->
          "english"
    MixinB =
      greet: ->
        "hola!"
      class:
        getLanguage: ->
          "spanish"
    class SimpleClass extends rib.Module
      @include MixinA, "MixinA"
      @include MixinB, "MixinB"
      getALanguage: ->
        @MixinA.class.getLanguage()
      getBLanguage: ->
        @MixinB.class.getLanguage()
    i = new SimpleClass()
    expect(i.getALanguage()).toEqual("english")
    expect(i.getBLanguage()).toEqual("spanish")
