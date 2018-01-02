"use strict";

var Clipboard = require("clipboard");

function makeFromX(runStringEmitter) {
  return function makeFromX$target (target) {
    return function makeFromX$stringEmitter (stringEmitter) {
      return function makeFromX$Eff () {
        return new Clipboard(target, {
          text: runStringEmitter(stringEmitter),
        });
      };
    };
  };
}

exports.fromElement = makeFromX(function makeFromX$fromElement (eff) {
  return function makeFromX$onText (/*elem*/) {
    return eff();
  };
});

exports.fromStringSelector = makeFromX(function makeFromX$fromStringSelector (effFunc) {
  return function makeFromX$onText (elem) {
    return effFunc(elem)();
  };
});

exports.fromElementWithTarget = function (el){
    return function(targetSelector) {
        return function() {
            return new Clipboard(el, {
                target: targetSelector
            });
        };
    };
};


exports.destroy = function destroy (clipboard) {
  return function destroy$Eff () {
    clipboard.destroy();
  };
};
