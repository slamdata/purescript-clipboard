module Main where

import Prelude

import CSS (Selector, fromString)
import Clipboard as C
import Control.Monad.Eff (Eff)
import DOM (DOM)
import DOM.Event.EventTarget (addEventListener, eventListener)
import DOM.HTML (window)
import DOM.HTML.Event.EventTypes (load)
import DOM.HTML.Types (windowToEventTarget, htmlDocumentToDocument)
import DOM.HTML.Window (document)
import DOM.Node.Element (getAttribute)
import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (Element, ElementId(ElementId), documentToNonElementParentNode)
import Data.Maybe (fromJust, fromMaybe)
import Data.Newtype (wrap)
import Partial.Unsafe (unsafePartial)

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

testInputSelector :: forall eff. Eff (dom :: DOM | eff) Unit
testInputSelector = do
 doc <- documentToNonElementParentNode <<< htmlDocumentToDocument <$> (document =<< window)
 let getInput = unsafePartial fromJust <$> getElementById (wrap "input-selector") doc
 button <- unsafePartial fromJust <$> getElementById (wrap "input-button-selector") doc
 void $ C.fromElementWithTarget button getInput

main :: forall eff. Eff (dom :: DOM | eff) Unit
main = onLoad do
  win <- window
  doc <- documentToNonElementParentNode <<< htmlDocumentToDocument <$> document win
  element <- getElementById (ElementId "test-element") doc
  fromMaybe (pure unit) $ testElement <$> element
  testSelector $ fromString ".test-selector"
  testInputSelector
