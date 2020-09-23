{ name = "pure-halogen-starter"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "halogen"
  , "random"
  , "routing"
  , "routing-duplex"
  , "node-process"
  , "purescript-graphql-client"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
