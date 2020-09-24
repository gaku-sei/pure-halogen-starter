{ name = "pure-halogen-starter"
, dependencies =
  [ "console"
  , "effect"
  , "foreign-generic"
  , "generics-rep"
  , "halogen"
  , "node-process"
  , "psci-support"
  , "purescript-graphql-client"
  , "random"
  , "remotedata"
  , "routing"
  , "routing-duplex"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
