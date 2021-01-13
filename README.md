# plantos

The plantOS mobile app.

## Getting Started

To run the app locally, run:

```bash
$ open -a Simulator.app
$ flutter run
```

## Releasing

```bash
$ flutter build ios --release --no-codesign
$ cd ios && fastlane release
```

```bash
$ flutter build appbundle
$ open https://play.google.com/console/u/0/developers/4955861190552911571/app/4974659361312005717/tracks/production # and click create new release
```

