module Component.HTML.Utils where

import Prelude
import Data.Route (Route, routeCodec)
import Halogen as H
import Halogen.HTML.Properties as HP
import Routing.Duplex (print)
import Tailwind as TW

href :: forall r i. Route -> HP.IProp ( href ∷ String | r ) i
href = HP.href <<< print routeCodec

tw :: forall r i. Array TW.Tailwind -> HP.IProp ( class ∷ String | r ) i
tw = HP.class_ <<< H.ClassName <<< TW.make
