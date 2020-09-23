module Component.Link where

import Prelude
import Capability.Navigate (class Navigate, navigate)
import Component.HTML.Utils as HU
import Data.Maybe (Maybe(..))
import Data.Route (Route)
import Data.Symbol (SProxy(..))
import Effect.Class (liftEffect)
import Foreign (unsafeToForeign)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Web.Event.Event as E
import Web.UIEvent.MouseEvent (MouseEvent, toEvent)

type Input slots m
  = { elements :: Array (HH.HTML (H.ComponentSlot HH.HTML slots m Action) Action)
    , route :: Route
    }

data Action
  = OnClick MouseEvent

component ::
  forall query slots m.
  Navigate m =>
  H.Component HH.HTML query (Input slots m) Void m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }
  where
  render { route, elements } =
    HH.a [ HU.href route, HE.onClick $ Just <<< OnClick ]
      elements

  handleAction = case _ of
    OnClick mouseEvent -> do
      let
        event = toEvent mouseEvent
      liftEffect $ E.preventDefault event
      liftEffect $ E.stopPropagation event
      H.gets _.route >>= flip navigate (unsafeToForeign {})

link ::
  forall action query slots r m.
  Navigate m =>
  String ->
  Route ->
  Array (HH.HTML (H.ComponentSlot HH.HTML slots m Action) Action) ->
  HH.HTML (H.ComponentSlot HH.HTML ( link :: H.Slot query Void String | r ) m action) action
link key route elements = HH.slot (SProxy :: _ "link") key component { route, elements } absurd
