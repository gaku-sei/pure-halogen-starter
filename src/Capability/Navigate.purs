module Capability.Navigate where

import Prelude
import Data.Route (Route)
import Effect.Class (class MonadEffect)
import Foreign (Foreign)
import Halogen (HalogenM, lift)

class
  (Monad m, MonadEffect m) <= Navigate m where
  navigate :: Route -> Foreign -> m Unit

instance navigateHalogenM :: Navigate m => Navigate (HalogenM state action slots output m) where
  navigate route = lift <<< navigate route
