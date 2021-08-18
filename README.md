# plantos

The plantOS mobile app.

## Architecture

Bloc classes maintain state of widgets.
Events are triggered by the UI and handled by the logic in the Bloc.
Blocs emit State objects - this is the UI that's updated by the bloc.

A worked example:

For example a sign up page might have a bunch of text fields and a sign up button.
It could have an event `SignUpTextFieldChangedEvent` which contains the current
values of all text fields. Once this is received by the bloc the values (email,
password, password confirmation) are stored in the bloc and an IsValid field is
computed and published as the state. When IsValid becomes true the sign up button
becomes clickable. The user clicks the sign up button and triggers a
SignUpPressedEvent. The bloc emits the state with the isLoading value set to
true, we make the api call using the text field values in the bloc. If the api
call is successful we can set isLoading to false and isSuccess to true,
otherwise we can send an error message back in the state for display.

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
