module Clipboard
  ( Clipboard
  , fromElement
  , fromCSSSelector
  , fromElementWithTarget
  , destroy
  ) where

import Prelude

import Control.Monad.Eff (Eff)
import DOM (DOM)
import CSS (Selector, selector)
import DOM.Node.Types (Element)

foreign import data Clipboard :: Type

foreign import fromElement
  :: forall eff
   . Element
  -> Eff (dom :: DOM | eff) String
  -> Eff (dom :: DOM | eff) Clipboard

fromCSSSelector
  :: forall eff
   . Selector
  -> (Element -> Eff (dom :: DOM | eff) String)
  -> Eff (dom :: DOM | eff) Clipboard
fromCSSSelector = selector >>> fromStringSelector

foreign import fromStringSelector
  :: forall eff
   . String
  -> (Element -> Eff (dom :: DOM | eff) String)
  -> Eff (dom :: DOM | eff) Clipboard

-- | Registers a click handler on an Event, which triggers the passed `Eff` and
-- | copies the text inside the returned element to the clipboard.
foreign import fromElementWithTarget
  :: forall eff
  . Element
  -> Eff (dom :: DOM | eff) Element
  -> Eff (dom :: DOM | eff) Clipboard

foreign import destroy
  :: forall eff
   . Clipboard
  -> Eff (dom :: DOM | eff) Unit
