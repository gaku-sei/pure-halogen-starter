module Env where

import Routing.PushState (PushStateInterface)

type Env
  = { globalMessage :: String
    , nav :: PushStateInterface
    }
