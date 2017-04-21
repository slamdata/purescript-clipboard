module Main where

import Prelude

import Control.Monad.Eff (Eff)

import Data.Maybe (fromMaybe)

import DOM (DOM)
import CSS (Selector, fromString)
import DOM.Event.EventTarget (addEventListener, eventListener)
import DOM.HTML (window)
import DOM.HTML.Event.EventTypes (load)
import DOM.HTML.Types (windowToEventTarget, htmlDocumentToDocument)
import DOM.HTML.Window (document)
import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (Element, ElementId(..), documentToNonElementParentNode)
import DOM.Node.Element (getAttribute)

import Clipboard as C

onLoad :: forall eff. (Eff (dom :: DOM | eff) Unit) -> Eff (dom :: DOM | eff) Unit
onLoad action
  = addEventListener load (eventListener (const action)) false
  <<< windowToEventTarget
  =<< window

stringFromAttr :: forall eff. String -> Element -> Eff (dom :: DOM | eff) String
stringFromAttr attr el = fromMaybe "" <$> getAttribute attr el

testElement :: forall eff. Element -> Eff (dom :: DOM | eff) Unit
testElement el = void $ C.fromElement el $ stringFromAttr "data-copy-text" el

testSelector :: forall eff. Selector -> Eff (dom :: DOM | eff) Unit
testSelector sel = void $ C.fromCSSSelector sel $ stringFromAttr "data-copy-text"

main :: forall eff. Eff (dom :: DOM | eff) Unit
main = onLoad do
  win <- window
  doc <- documentToNonElementParentNode <<< htmlDocumentToDocument <$> document win
  element <- getElementById (ElementId "test-element") doc
  fromMaybe (pure unit) $ testElement <$> element
  testSelector $ fromString ".test-selector"
