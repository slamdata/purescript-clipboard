module Clipboard
  ( Clipboard
  , fromElement
  , fromCSSSelector
  , fromElementWithTarget
  , destroy
  ) where

import Prelude

import Effect (Effect)
import CSS (Selector, selector)
import Web.DOM.Element (Element)

foreign import data Clipboard :: Type

foreign import fromElement
  :: Element
  -> Effect String
  -> Effect Clipboard

fromCSSSelector
  :: Selector
  -> (Element -> Effect String)
  -> Effect Clipboard
fromCSSSelector = selector >>> fromStringSelector

foreign import fromStringSelector
  :: String
  -> (Element -> Effect String)
  -> Effect Clipboard

-- | Registers a click handler on an Event, which triggers the passed `Eff` and
-- | copies the text inside the returned element to the clipboard.
foreign import fromElementWithTarget
  :: Element
  -> Effect Element
  -> Effect Clipboard

foreign import destroy
  :: Clipboard
  -> Effect Unit
