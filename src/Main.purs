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
import Routing.PushState (makeInterface, matchesWith)

main :: Effect Unit
main =
  HA.runHalogenAff do
    nav <- liftEffect makeInterface
    let
      rootComponent =
        H.hoist
          ( runAppM
              { apiUrl: "https://countries.trevorblades.com"
              , globalMessage: "Hello from the Env!"
              , nav
              }
          )
          Router.component
    halogenIO <- HA.awaitBody >>= runUI rootComponent unit
    liftEffect $ nav
      # matchesWith (parse routeCodec) \old new ->
          when (old /= Just new) do
            launchAff_ $ halogenIO.query $ H.tell $ Router.Navigate new
