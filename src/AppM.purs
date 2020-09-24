module AppM where

import Prelude
import Api.Object.Country as Country
import Api.Object.Language as Language
import Api.Query as Query
import Capability.Countries (class Countries)
import Capability.GraphQL (class GraphQL, query)
import Capability.Navigate (class Navigate)
import Capability.Random (class Random)
import Control.Monad.Reader (class MonadAsk, ReaderT, asks, runReaderT)
import Data.Maybe (fromMaybe)
import Data.Newtype (class Newtype)
import Data.Route (routeCodec)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Random (randomInt)
import Env (Env)
import GraphQLClient (defaultInput, defaultRequestOptions, graphqlMutationRequest, graphqlQueryRequest)
import Network.RemoteData (fromEither, toMaybe)
import Routing.Duplex (print)
import Type.Equality (class TypeEquals, from)

newtype AppM a
  = AppM (ReaderT Env Aff a)

derive instance newtypeAppM :: Newtype (AppM a) _

derive newtype instance functorAppM :: Functor AppM

derive newtype instance applyAppM :: Apply AppM

derive newtype instance applicativeAppM :: Applicative AppM

derive newtype instance bindAppM :: Bind AppM

derive newtype instance monadAppM :: Monad AppM

derive newtype instance monadEffectAppM :: MonadEffect AppM

derive newtype instance monadAffAppM :: MonadAff AppM

instance monadAskAppM :: TypeEquals e Env => MonadAsk e AppM where
  ask = AppM $ asks from

runAppM :: Env -> AppM ~> Aff
runAppM env (AppM m) = runReaderT m env

instance randomAppM :: Random AppM where
  rand min = liftEffect <<< randomInt min

instance navigateAppM :: Navigate AppM where
  navigate route state = do
    nav <- asks _.nav
    liftEffect $ nav.pushState state $ print routeCodec route

instance graphQLAppM :: GraphQL AppM where
  query q = do
    apiUrl <- asks _.apiUrl
    liftAff $ fromEither <$> graphqlQueryRequest apiUrl defaultRequestOptions q
  mutation m = do
    apiUrl <- asks _.apiUrl
    liftAff $ fromEither <$> graphqlMutationRequest apiUrl defaultRequestOptions m

instance countriesAppM :: Countries AppM where
  getCountries = fromMaybe [] <<< toMaybe <$> query countries
    where
    countries = Query.countries defaultInput countrySelection

    countrySelection =
      { code: _, name: _, languages: _ }
        <$> Country.code
        <*> Country.name
        <*> Country.languages Language.name
