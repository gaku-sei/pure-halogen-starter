module Component.Router where

import Prelude
import Capability.Countries (class Countries)
import Capability.Navigate (class Navigate, navigate)
import Capability.Random (class Random)
import Component.HTML.NotFound (notFound)
import Control.Monad.Reader (class MonadAsk, asks)
import Data.Either (hush)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Route (Route(..), routeCodec)
import Data.Symbol (SProxy(..))
import Effect.Class (class MonadEffect)
import Env (Env)
import Foreign (unsafeToForeign)
import Halogen (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Page.About as About
import Page.Countries as Countries
import Page.Home as Home
import Routing.Duplex (parse)

type State
  = { route :: Maybe Route
    }

data Action
  = Initialize

data Query a
  = Navigate Route a

component ::
  forall m.
  MonadEffect m =>
  MonadAsk Env m =>
  Random m =>
  Navigate m =>
  Countries m =>
  H.Component HH.HTML Query Unit Void m
component =
  H.mkComponent
    { initialState
    , render
    , eval:
      H.mkEval
        $ H.defaultEval
            { initialize = Just Initialize
            , handleAction = handleAction
            , handleQuery = handleQuery
            }
    }
  where
  initialState = const { route: Nothing }

  render { route } =
    route
      # maybe notFound case _ of
          Home -> HH.slot (SProxy :: _ "home") unit Home.component unit absurd
          About -> HH.slot (SProxy :: _ "about") unit About.component unit absurd
          Countries -> HH.slot (SProxy :: _ "countries") unit Countries.component unit absurd

  handleAction = case _ of
    Initialize -> do
      path <- _.path <$> (liftEffect <<< _.locationState =<< asks _.nav)
      let
        newPath = fromMaybe Home $ hush $ parse routeCodec path
      navigate newPath $ unsafeToForeign {}

  handleQuery :: forall slots a. Query a -> H.HalogenM State Action slots Void m (Maybe a)
  handleQuery = case _ of
    Navigate newRoute a -> do
      { route } <- H.get
      when (route /= Just newRoute) do
        H.modify_ _ { route = Just newRoute }
      pure $ Just a
