# Coach E

Flutter mobile app for coaching workflows.

## Current milestone

The app is currently set up with:

- App shell using `go_router`.
- Shared theme from `cyr_app_kit`.
- Local-only hardcoded auth flow.
- Home screen with a coaching entry point.
- Placeholder coaching session screen.
- Common dependencies copied from Stranger Confide for networking, DI, codegen,
  i18n, media, realtime, and app utilities.

Coach E will use its own backend later. It does not use the Stranger Confide backend.

## Local dependencies

This project depends on local packages:

- `/Users/hainguyen/dev/cyr_flutter_core`
- `/Users/hainguyen/dev/talkfirst/cyr_app_kit`

## Run

```bash
flutter pub get
flutter run
```

## Verify

```bash
dart format .
flutter analyze
flutter test
```

## Planning docs

- `docs/coach_e_requirements.md`
- `docs/stranger_confide_reuse_plan.md`
- `docs/project_state_and_next_prompt.md`
