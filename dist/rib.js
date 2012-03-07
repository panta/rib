(function() {
  var AssertException, MixinA, MixinB, Module, SimpleClass, UID, UUID, assert, assertEqual, assertSame, dbg, module, moduleKeywords, msg, namespace, root, uidCounter,
    __slice = Array.prototype.slice,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  if (typeof window !== "undefined" && window !== null) {
    if (typeof module === "undefined" || module === null) module = {};
    root.mixins = module;
  } else {
    module = root;
  }

  AssertException = (function() {

    function AssertException() {
      var args, message;
      message = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      this.message = message;
      this.args = args;
    }

    AssertException.prototype.toString = function() {
      return "AssertException: " + this.message;
    };

    return AssertException;

  })();

  assert = function(exp, message) {
    if (message == null) message = null;
    if (!exp) {
      message || (message = "assertion failed: " + exp + " is not true");
      throw new AssertException(message);
    }
  };

  assertEqual = function(v1, v2, message) {
    var r;
    if (message == null) message = null;
    if (typeof _ !== "undefined" && _ !== null) {
      r = _.isEqual(v1, v2);
    } else {
      r = v1 == v2;
    }
    if (!r) {
      message || (message = "assertion failed: " + v1 + " != " + v2);
      throw new AssertException(message);
    }
  };

  assertSame = function(v1, v2, message) {
    if (message == null) message = null;
    if (!(v1 === v2)) {
      message || (message = "assertion failed: " + v1 + " is not " + v2);
      throw new AssertException(message);
    }
  };

  module.AssertException = AssertException;

  module.assert = assert;

  module.assertEqual = assertEqual;

  module.assertSame = assertSame;

  namespace = function(target, name, block) {
    var item, top, _i, _len, _ref, _ref2;
    if (arguments.length < 3) {
      _ref = [(typeof exports !== 'undefined' ? exports : window)].concat(__slice.call(arguments)), target = _ref[0], name = _ref[1], block = _ref[2];
    }
    top = target;
    _ref2 = name.split('.');
    for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
      item = _ref2[_i];
      target = target[item] || (target[item] = {});
    }
    return block(target, top);
  };

  module.namespace = namespace;

  module.dbgEnable = true;

  dbg = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    if (module.dbgEnable) {
      args.unshift("[DEBUG]");
      return typeof console !== "undefined" && console !== null ? typeof console.log === "function" ? console.log.apply(console, args) : void 0 : void 0;
    }
  };

  module.dbg = dbg;

  uidCounter = 0;

  UID = function(prefix) {
    return (prefix || '') + uidCounter++;
  };

  module.UID = UID;

  UUID = function() {
    return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(c) {
      var r, v;
      r = Math.random() * 16 | 0;
      v = (c === "x" ? r : r & 0x3 | 0x8);
      return v.toString(16);
    });
  };

  module.UUID = UUID;

  moduleKeywords = ['class', 'extended', 'included', '__name__', '__mixin__', '__mixins__', '__extends__'];

  Module = (function() {

    Module.include = function(obj, name) {
      var key, value, wrapper, _ref, _ref2, _value,
        _this = this;
      if (name == null) name = null;
      if (!obj) throw 'include(obj) requires obj';
      name = name != null ? name : obj.__name__;
      obj.__name__ = name;
      if (name) obj.__name__ = name;
      obj.__mixin__ = obj;
      if (this.__mixins__ == null) this.__mixins__ = [];
      this.__mixins__.push(obj);
      if (obj.__extends__ == null) obj.__extends__ = [];
      obj.__extends__.push(this);
      for (key in obj) {
        value = obj[key];
        if (__indexOf.call(moduleKeywords, key) < 0) this.prototype[key] = value;
      }
      if (obj["class"]) {
        if (name) obj["class"].__name__ = name;
        obj["class"].__mixin__ = obj;
        _ref = obj["class"];
        for (key in _ref) {
          value = _ref[key];
          if (__indexOf.call(moduleKeywords, key) < 0) {
            if (typeof value === "function") {
              _value = value;
              wrapper = function() {
                var args;
                args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
                return _value.apply(_this, args);
              };
              obj["class"][key] = wrapper;
              this[key] = wrapper;
            } else {
              this[key] = value;
            }
          }
        }
      }
      if (name != null) {
        this[name] = obj;
        this.prototype[name] = obj;
      }
      if ((_ref2 = obj.included) != null) _ref2.apply(this);
      return this;
    };

    function Module() {
      if (typeof this.init === "function") this.init.apply(this, arguments);
    }

    return Module;

  })();

  module.Module = Module;

  msg = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return typeof console !== "undefined" && console !== null ? typeof console.log === "function" ? console.log.apply(console, args) : void 0 : void 0;
  };

  MixinA = {
    __name__: "MixinA",
    simpleMethodFromA: function() {
      return "simple_A";
    },
    methodFromA: function() {
      msg("methodFromA called");
      return this.getDoubleA();
    },
    greet: function() {
      msg("MixinA greet");
      msg(this);
      this.a *= 2;
      return msg("hello " + this.a);
    },
    "class": {
      ClassMethod: function() {
        msg("class method A");
        return msg(this);
      }
    }
  };

  MixinB = {
    __name__: "MixinB",
    simpleMethodFromB: function() {
      return "simple_B";
    },
    methodFromB: function() {
      msg("methodFromB called");
      return this.getHalfA();
    },
    greet: function() {
      msg("MixinB greet");
      msg(this);
      this.a += 1;
      return msg("hola! " + this.a);
    },
    "class": {
      ClassMethod: function() {
        msg("class method B");
        return msg(this);
      },
      GetThis: function() {
        msg(this);
        return this;
      }
    }
  };

  SimpleClass = (function(_super) {

    __extends(SimpleClass, _super);

    SimpleClass.include(MixinA);

    SimpleClass.include(MixinB);

    function SimpleClass() {
      msg("constructor");
      this.a = 4;
      msg(this);
    }

    SimpleClass.prototype.getDoubleA = function() {
      return this.a * 2;
    };

    SimpleClass.prototype.getHalfA = function() {
      return this.a / 2;
    };

    SimpleClass.prototype.testInherited1 = function() {
      var r;
      msg("testInherited1");
      r = this.methodFromA();
      assert(r === 8);
      return r;
    };

    SimpleClass.prototype.testInherited2 = function() {
      var r;
      msg("testInherited2");
      r = this.methodFromB();
      assert(r === 2);
      return r;
    };

    SimpleClass.prototype.testInherited = function() {
      msg("testInherited");
      this.methodFromA();
      return this.methodFromB();
    };

    SimpleClass.prototype.callGetThis = function() {
      return this.MixinB["class"].GetThis();
    };

    SimpleClass.prototype.greet = function() {
      msg("SimpleClass greet");
      this.MixinA.greet.apply(this);
      this.MixinB.greet.apply(this);
      this.MixinA["class"].ClassMethod();
      return this.MixinB["class"].ClassMethod();
    };

    return SimpleClass;

  })(Module);

  module.SimpleClass = SimpleClass;

}).call(this);
