module Page.About where

import Prelude
import Capability.Navigate (class Navigate)
import Component.Link (link)
import Data.Route (Route(..))
import Halogen as H
import Halogen.HTML as HH

component :: forall query m. Navigate m => H.Component HH.HTML query Unit Void m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval H.defaultEval
    }
  where
  render _state =
    HH.div_
      [ HH.div_ [ HH.text "About page" ]
      , HH.div_ [ link Home [ HH.text "home" ] ]
      ]
