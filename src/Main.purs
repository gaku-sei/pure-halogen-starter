module Main where

import Prelude
import AppM (runAppM)
import Component.Router as Router
import Control.Monad.Except (runExcept, throwError)
import Data.Either (Either(..))
import Data.Foldable (intercalate)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Route (routeCodec)
import Effect (Effect)
import Effect.Aff (error, launchAff_)
import Foreign (renderForeignError)
import Foreign.Generic (class Decode, Foreign, decode, defaultOptions, genericDecode)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Routing.Duplex (parse)
import Routing.PushState (makeInterface, matchesWith)

newtype Config
  = Config { apiUrl :: String, globalMessage :: String }

derive instance newtypeConfig :: Newtype Config _

derive instance genericConfig :: Generic Config _

instance decodeConfig :: Decode Config where
  decode = genericDecode defaultOptions { unwrapSingleConstructors = true }

main :: Foreign -> Effect Unit
main config =
  HA.runHalogenAff do
    { apiUrl, globalMessage } <- case runExcept $ decode config of
      Right (Config c) -> pure c
      Left e -> throwError $ error $ "Configuration error: " <> (intercalate "\n" $ renderForeignError <$> e)
    nav <- liftEffect makeInterface
    let
      rootComponent = H.hoist (runAppM { apiUrl, globalMessage, nav }) Router.component
    halogenIO <- HA.awaitBody >>= runUI rootComponent unit
    liftEffect $ nav
      # matchesWith (parse routeCodec) \old new ->
          when (old /= Just new) do
            launchAff_ $ halogenIO.query $ H.tell $ Router.Navigate new
