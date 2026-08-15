# Coach E

Flutter mobile app. This repo is a Coach E product that reuses selected architecture from:

`/Users/hainguyen/dev/talkfirst/stranger_confide`

## Read first

- `docs/coach_e_requirements.md`
- `docs/stranger_confide_reuse_plan.md`
- If backend/API work is in scope, read the relevant reference API doc from `/Users/hainguyen/dev/talkfirst/stranger_confide/docs/api/` instead of preloading every API file.

## Engineering conventions

- Prefer the established Stranger Confide architecture unless a product requirement says otherwise.
- Coach E does not use the Stranger Confide backend. Do not port endpoint-specific code until Coach E backend contracts exist.
- Use hardcoded/local auth for the first milestone so coaching features can move first.
- Use feature folders with data/domain/presentation or the existing BLoC-oriented layout.
- Use `go_router` for navigation.
- Use `flutter_bloc` for feature state when porting Stranger Confide flows.
- Use immutable states/models with `freezed` and `json_serializable`.
- Use `dio` and `retrofit` for REST API clients.
- Use `get_it` and `injectable` for dependency injection if the app keeps the reference architecture.
- Keep generated files in sync by running build runner after model/API/DI changes.

## Socket and realtime rules

These rules only apply if Coach E later reuses realtime/chat patterns.

- Register all socket listeners before connecting.
- Matchmaking and chat are separate namespaces in the reference backend: `/matchmaking` and `/chat`.
- Matchmaking disconnect means the user is removed from queue; do not keep showing stale searching state.
- Chat disconnect does not close the room; reconnect and emit `room:join` again.
- On app resume, ask the backend for truth with `GET /api/rooms/active`.
- Do not optimistically append text chat messages; wait for server `chat:message`.
- Treat `room:closed` and `room:access_denied` as separate terminal cases.

## Commands

Use these after dependencies/codegen are configured:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze
flutter test
```

## Open decisions

Resolved:

- Coach E uses its own backend later.
- Local packages `cyr_flutter_core` and `cyr_app_kit` are allowed.
- First milestone is app shell plus hardcoded auth, with coaching features prioritized.
