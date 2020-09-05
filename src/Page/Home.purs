module Page.Home where

import Prelude
import Capability.Navigate (class Navigate)
import Capability.Random (class Random, rand)
import Component.HTML.Utils as HU
import Component.Link (link)
import Control.Monad.Reader (class MonadAsk, asks)
import Data.Maybe (Maybe(..))
import Data.Route (Route(..))
import Halogen as H
import Halogen.HTML as HH
import Tailwind as TW

data Action
  = Initialize

component ::
  forall query r m.
  MonadAsk { globalMessage :: String | r } m =>
  Navigate m =>
  Random m =>
  H.Component HH.HTML query Unit Void m
component =
  H.mkComponent
    { initialState
    , render
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleAction = handleAction
            , initialize = Just Initialize
            }
    }
  where
  initialState = const { message: "", number: 0 }

  render { message, number } =
    HH.div [ HU.tw [ TW.m1 ] ]
      [ HH.div_ [ HH.text "Hello" ]
      , HH.div_ [ HH.text message ]
      , HH.div_ [ HH.text $ "Random number: " <> show number ]
      , HH.div_ [ link About [ HH.text "about" ] ]
      ]

  handleAction = case _ of
    Initialize -> H.put =<< { message: _, number: _ } <$> asks _.globalMessage <*> rand 0 100
