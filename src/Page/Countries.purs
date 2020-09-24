module Page.Countries where

import Prelude
import Capability.Countries (class Countries, getCountries)
import Capability.Countries as Countries
import Capability.Navigate (class Navigate)
import Component.HTML.Utils as HU
import Component.Link (link)
import Data.Array (catMaybes)
import Data.Foldable (intercalate)
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Data.Route (Route(..))
import Halogen as H
import Halogen.HTML as HH
import Tailwind as TW

data Action
  = Initialize

data State
  = Init
  | Loaded (Array Countries.Response)

component ::
  forall query m.
  Navigate m =>
  Countries m =>
  H.Component HH.HTML query Unit Void m
component =
  H.mkComponent
    { initialState: const Init
    , render
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleAction = handleAction
            , initialize = Just Initialize
            }
    }
  where
  render state =
    HH.div [ HU.tw [ TW.m1 ] ]
      [ HH.div_ [ HH.text "Countries" ]
      , HH.div_
          $ case state of
              Init -> [ HH.text "loading..." ]
              Loaded countries -> viewCountry <$> countries
      , HH.div_
          [ link "home" Home
              [ HH.span [ HU.tw [ TW.underline, TW.textBlue500 ] ] [ HH.text "Home" ]
              ]
          ]
      ]

  viewCountry { code, name, languages } =
    HH.div_
      [ HH.text
          $ "Code: "
          <> unwrap code
          <> ", Name: "
          <> name
          <> ", Languages: "
          <> (intercalate ", " $ catMaybes languages)
      ]

  handleAction = case _ of
    Initialize -> H.put =<< Loaded <$> getCountries
