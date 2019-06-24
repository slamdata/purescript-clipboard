module Main where

import Prelude

import CSS (Selector, fromString)
import Clipboard as C
import Data.Maybe (fromJust, fromMaybe)
import Effect (Effect)
import Partial.Unsafe (unsafePartial)
import Web.DOM.Element (Element)
import Web.DOM.Element as Element
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.Event.EventTypes (load)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.Window as Window

onLoad :: Effect Unit -> Effect Unit
onLoad action = do
  listener <- eventListener $ const action
  win <- map Window.toEventTarget window
  addEventListener load listener false win

stringFromAttr :: String -> Element -> Effect String
stringFromAttr attr el = fromMaybe "" <$> Element.getAttribute attr el

testElement :: Element -> Effect Unit
testElement el = void $ C.fromElement el $ stringFromAttr "data-copy-text" el

testSelector :: Selector -> Effect Unit
testSelector sel = void $ C.fromCSSSelector sel $ stringFromAttr "data-copy-text"

testInputSelector :: Effect Unit
testInputSelector = do
 doc <- HTMLDocument.toNonElementParentNode <$> (Window.document =<< window)
 let getInput = unsafePartial fromJust <$> getElementById "input-selector" doc
 button <- unsafePartial fromJust <$> getElementById "input-button-selector" doc
 void $ C.fromElementWithTarget button getInput

main :: Effect Unit
main = onLoad do
  win <- window
  doc <- HTMLDocument.toNonElementParentNode <$> Window.document win
  element <- getElementById "test-element" doc
  fromMaybe (pure unit) $ testElement <$> element
  testSelector $ fromString ".test-selector"
  testInputSelector
