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
