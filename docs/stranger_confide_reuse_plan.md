# Stranger Confide Reuse Plan

Source project:

`/Users/hainguyen/dev/talkfirst/stranger_confide`

## What can be reused directly

These files/directories are strong candidates for reuse as patterns. Direct porting should be selective because `coach_e` will use a separate backend and coaching product domain:

- `docs/api/` - REST API contract style, not endpoint content.
- `docs/MOBILE_CHAT_SPEC.md` - realtime feature spec style if Coach E later adds realtime coaching.
- `handbook/mobile-matchmaking-chat-sync.md` - socket/resume lifecycle reference if realtime returns.
- `lib/core/app_bootstrap.dart` - app-kit bootstrap, base URL, default headers, session-expired routing.
- `lib/core/di/` - get_it/injectable setup.
- `lib/data/datasources/*_remote_datasource.dart` - Retrofit API clients.
- `lib/data/models/request/` and `lib/data/models/response/` - Freezed/JSON models.
- `lib/data/repositories/base_repository.dart` and domain repositories/usecases - app result/error wrapping.
- `lib/data/datasources/matchmaking_socket_service.dart` - socket service pattern.
- `lib/features/matchmaking/` - queue state machine and UI flow.
- `lib/features/chat/` - chat state machine, room lifecycle, UI widgets.
- `lib/router/app_router.dart` - route structure and startup branching.
- `assets/translations/` - i18n seed files.

## What should be adapted before reuse

- Package imports must change from `stranger_confide` to `coach_e`.
- Product text, app title, icons, bundle identifiers, and theme should be rebranded.
- `firebase_options.dart`, Google Sign-In, Facebook Sign-In, and push notification setup are app-specific and must be regenerated/configured.
- `pubspec.yaml` currently depends on local packages:
  - `/Users/hainguyen/dev/cyr_flutter_core`
  - `/Users/hainguyen/dev/talkfirst/cyr_app_kit`
- Generated files (`*.g.dart`, `*.freezed.dart`, `injection.config.dart`) can be copied for a fast snapshot, but should be regenerated after package names and dependencies are finalized.

## Core architecture to carry forward

- Flutter SDK `^3.9.0`.
- `go_router` for routing.
- `flutter_bloc` for app state in features.
- `freezed` and `json_serializable` for immutable states and DTOs.
- `dio` and `retrofit` for REST.
- `socket_io_client` for realtime matchmaking/chat.
- `get_it` and `injectable` for DI.
- `easy_localization` for i18n.
- `flutter_dotenv` for environment config.
- `firebase_messaging` for push routing, if push is in scope.

## Suggested project structure

```text
lib/
  core/
    app_bootstrap.dart
    di/
    locale/
    push_notification_service.dart
  data/
    datasources/
    models/
    repositories/
  domain/
    enums/
    repositories/
    services/
    usecases/
  features/
    auth/
    profile/
    matchmaking/
    chat/
    home/
    splash/
  router/
```

## First implementation milestone

The confirmed first milestone is app shell plus hardcoded auth:

1. Add local package dependencies and routing/state dependencies.
2. Use `cyr_app_kit` theme.
3. Add local-only auth state.
4. Replace the default counter screen with splash/login/home routing.
5. Add a coaching placeholder route as the next feature entry point.
6. Run `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test`.

After that, build coaching workflows before backend integration.

## Rule files prepared for this project

- `AGENTS.md` - project-specific agent/developer instructions.
- `.cursor/rules/rules_10k.md` - Flutter implementation rules adapted from the reference.

## Decisions

- Coach E will not reuse the Stranger Confide backend.
- Local dependencies `cyr_flutter_core` and `cyr_app_kit` are allowed.
- First user-facing work is app shell plus hardcoded auth, then coaching features.
- Avoid porting generated networking/model code until Coach E backend contracts exist.
