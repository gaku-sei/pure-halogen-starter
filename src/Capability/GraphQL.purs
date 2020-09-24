module Capability.GraphQL where

import Prelude
import GraphQLClient (GraphQLError, Scope__RootMutation, Scope__RootQuery, SelectionSet)
import Halogen (HalogenM, lift)
import Network.RemoteData (RemoteData)

class
  Monad m <= GraphQL m where
  query :: forall a. SelectionSet Scope__RootQuery a -> m (RemoteData (GraphQLError a) a)
  mutation :: forall a. SelectionSet Scope__RootMutation a -> m (RemoteData (GraphQLError a) a)

instance graphQLHalogenM :: GraphQL m => GraphQL (HalogenM state action slots output m) where
  query = lift <<< query
  mutation = lift <<< mutation
