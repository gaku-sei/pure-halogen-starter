module Capability.Countries where

import Prelude
import Api.Scalars (Id)
import Data.Maybe (Maybe)
import Halogen (HalogenM, lift)

type Response
  = { name :: String
    , code :: Id
    , languages :: Array (Maybe String)
    }

class
  Monad m <= Countries m where
  getCountries :: m (Array Response)

instance navigateHalogenM :: Countries m => Countries (HalogenM state action slots output m) where
  getCountries = lift getCountries
