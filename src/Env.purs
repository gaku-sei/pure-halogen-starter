module Env where

import Routing.PushState (PushStateInterface)

type Env
  = { apiUrl :: String
    , globalMessage :: String
    , nav :: PushStateInterface
    }
