module Component.HTML.Utils where

import Prelude
import Data.Route (Route, routeCodec)
import Halogen.HTML.Properties as HP
import Routing.Duplex (print)

href :: forall r i. Route -> HP.IProp ( href ∷ String | r ) i
href = HP.href <<< append "#" <<< print routeCodec
