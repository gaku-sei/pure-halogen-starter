module Capability.GraphQL where

import Prelude
import Data.Either (Either)
import GraphQLClient (GraphQLError, Scope__RootMutation, Scope__RootQuery, SelectionSet)
import Halogen (HalogenM, lift)

class
  Monad m <= GraphQL m where
  query :: forall a. SelectionSet Scope__RootQuery a -> m (Either (GraphQLError a) a)
  mutation :: forall a. SelectionSet Scope__RootMutation a -> m (Either (GraphQLError a) a)

instance graphQLHalogenM :: GraphQL m => GraphQL (HalogenM state action slots output m) where
  query = lift <<< query
  mutation = lift <<< mutation
