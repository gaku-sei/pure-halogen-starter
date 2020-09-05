{ name = "pure-halogen-starter"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "halogen"
  , "random"
  , "routing"
  , "routing-duplex"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
