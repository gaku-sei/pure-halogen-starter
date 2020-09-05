module Capability.Random where

import Prelude
import Halogen (HalogenM, lift)

class
  Monad m <= Random m where
  rand :: Int -> Int -> m Int

instance randomHalogenM :: Random m => Random (HalogenM state action slots output m) where
  rand x = lift <<< rand x
