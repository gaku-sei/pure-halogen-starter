module Component.HTML.NotFound where

import Halogen.HTML as HH

notFound :: forall props action. HH.HTML props action
notFound = HH.div_ [ HH.text "Route not found" ]
