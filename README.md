## Pure Halogen Starter

This starter is a light weighted (and slightly tweaked) alternative to the [Halogen Real World](https://github.com/thomashoneyman/purescript-halogen-realworld) repository by [Thomas Honeyman](https://thomashoneyman.com/).

It contains only a couple of pages, but also implements the [capability pattern](https://thomashoneyman.com/guides/real-world-halogen/push-effects-to-the-edges/) and provides all you need to get started 😁

## Features

- [Halogen](https://purescript-halogen.github.io/purescript-halogen/)
- [Parcel](https://parceljs.org/)
- [Serve](https://www.npmjs.com/package/serve) to serve app
- [Zephyr](https://github.com/coot/zephyr) for dead code elimination in production
- Tailwind using [Tailwind Generator](https://github.com/scoville/tailwind-generator)
- GraphQL thanks to [PureScript Graphql Client](https://github.com/purescript-graphql-client/purescript-graphql-client)
- .env files support

## Incoming

Here are some of the incoming features:

- ...

## Dead Code Elimination

The `build` script uses [Zephyr](https://github.com/coot/zephyr) under the hood to minify the JS bundle. If you want to enable DCE you need to install the binary (optional).
