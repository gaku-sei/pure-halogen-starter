module Main where

import Prelude
import AppM (runAppM)
import Component.Router as Router
import Data.Maybe (Maybe(..))
import Data.Route (routeCodec)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Routing.Duplex (parse)
import Routing.Hash (matchesWith)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    let
      env = { globalMessage: "Hello from the Env!" }

      rootComponent = H.hoist (runAppM env) Router.component
    halogenIO <- runUI rootComponent unit body
    void $ liftEffect
      $ matchesWith (parse routeCodec) \old new -> do
          when (old /= Just new) do
            launchAff_ $ halogenIO.query $ H.tell $ Router.Navigate new
