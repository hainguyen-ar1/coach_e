# Flutter Rules for Coach E

## General

- Write concise, modern Dart.
- Prefer immutable data and `const` widgets.
- Keep widgets small and composable.
- Use `dart:developer` logging instead of `print`.
- Prefer package imports consistently.
- Avoid `!` unless the value is guaranteed by control flow or API contract.
- Use custom error handling instead of silent failures.

## Architecture

- Follow the local project architecture in `AGENTS.md`.
- For Stranger Confide ports, keep the BLoC/usecase/repository/datasource boundaries.
- API DTOs belong in `lib/data/models`.
- Feature state belongs near the feature, usually under `lib/features/<feature>/bloc`.
- Business actions should go through usecases rather than calling datasources from UI.
- Add abstractions only when they remove real duplication or clarify a boundary.

## Flutter UI

- Use Material 3.
- Support safe areas and dynamic text scaling.
- Use `ListView.builder` or slivers for long lists.
- Avoid network or expensive work in `build`.
- Add semantic labels for important controls.
- Keep text readable in Vietnamese and English.

## REST

- Use Retrofit annotations for API clients.
- Keep base URL and default headers centralized.
- Wrap Dio failures into app-level error/result types.
- Read the relevant API domain doc before changing a contract.

## Socket

- Listeners must be registered before connect.
- Chat text send is server-confirmed, not optimistic.
- Chat image upload uses REST, not `chat:send`.
- Chat reconnect must emit `room:join` again.
- Matchmaking reconnect must not imply the user is still queued.

## Codegen and verification

- After changing Freezed, JSON, Retrofit, or Injectable files, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

- Before handing off implementation work, run:

```bash
dart format .
flutter analyze
flutter test
```
