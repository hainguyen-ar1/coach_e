# Coach E Project State And Next Prompt

Updated: 2026-08-15

## What the project has now

### Product direction

- Coach E is a coaching product.
- Coach E will use its own backend later.
- The app should reuse selected architecture and package conventions from Stranger Confide, not Stranger Confide's backend or chat domain by default.
- Development should prioritize coaching features before backend integration.

### App shell

- `lib/main.dart` starts `CoachEApp`.
- The app uses `MaterialApp.router`.
- The app uses shared `AppTheme.light` and `AppTheme.dark` from `cyr_app_kit`.
- `ThemeCubit` from `cyr_app_kit` is already wired.

### Routing

Router file:

- `lib/router/app_router.dart`

Routes:

- `/` - splash
- `/login` - hardcoded login
- `/home` - authenticated home
- `/coaching` - first coaching placeholder

Auth guard behavior:

- `checking` state stays on splash.
- `unauthenticated` redirects to login.
- `authenticated` redirects away from splash/login to home.

### Auth

Auth file:

- `lib/core/auth/auth_cubit.dart`

Current behavior:

- Local-only and temporary.
- `AuthCubit` starts in `checking`.
- After a short delay it emits `unauthenticated`.
- Email/password login accepts any non-empty email and password with at least 4 characters.
- Demo login creates a fake user.
- Sign out returns to unauthenticated state.

This should stay simple until coaching flows need backend identity.

### UI screens

Existing screens:

- `lib/features/splash/splash_page.dart`
- `lib/features/login/login_page.dart`
- `lib/features/home/home_page.dart`
- `lib/features/coaching/coaching_page.dart`

Current coaching feature:

- Local-only interactive flow.
- Lets the learner choose a goal.
- Lets the learner choose a practice mode.
- Generates a deterministic prompt.
- Accepts a text response.
- Generates deterministic placeholder feedback.
- Shows a short session summary.
- Saves completed session summaries locally.
- Shows recent sessions on Home.
- Supports reopening read-only session summaries.
- Supports clearing local history for development.
- Supports reset/start-over.

### Dependencies

Local packages:

- `/Users/hainguyen/dev/cyr_flutter_core`
- `/Users/hainguyen/dev/talkfirst/cyr_app_kit`

Core app packages already added:

- `go_router`
- `flutter_bloc`
- `freezed_annotation`
- `json_annotation`
- `dio`
- `retrofit`
- `socket_io_client`
- `get_it`
- `injectable`
- `intl`
- `flutter_dotenv`
- `flutter_animate`
- `gap`
- `shared_preferences`
- `easy_localization`
- `google_sign_in`
- `flutter_facebook_auth`
- `image_picker`
- `firebase_core`
- `firebase_messaging`
- `flutter_svg`

Dev/codegen packages already added:

- `freezed`
- `json_serializable`
- `retrofit_generator`
- `injectable_generator`
- `build_runner`

Android note:

- Core library desugaring is enabled for Android because `flutter_local_notifications` is pulled through shared package dependencies.

### Tests and verification

Current widget test:

- `test/widget_test.dart`
- Verifies splash/login/demo auth/home/coaching route.

Last known successful checks:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build apk --debug
git diff --check
```

## What has been completed from the next feature slice

- Coaching data models:
  - `CoachingGoal`
  - `PracticeMode`
  - `CoachingPrompt`
  - `CoachingFeedback`
  - `CoachingSessionDraft`
- Coaching state management:
  - `CoachingCubit`
  - `CoachingState`
  - `CoachingStep`
- Interactive `/coaching` UI:
  - goal picker
  - mode picker
  - prompt panel
  - response input
  - feedback panel
  - summary panel
  - reset/start-over action
- Local coaching session history:
  - `CoachingSessionSummary`
  - `CoachingHistoryRepository` backed by `shared_preferences`
  - `CoachingHistoryCubit`
  - Home recent sessions section
  - read-only session summary route
  - clear-history action

## What is still missing

- No backend/API contracts for Coach E.
- No DI setup yet for feature services/repositories.
- No i18n assets wired yet.
- No Firebase initialization or push flow wired yet.
- No real AI/backend feedback yet.
- No audio recording flow yet.
- No editable/resumable in-progress session drafts yet.

## Recommended next feature slice

Build the first deeper coaching workflow, still without backend.

The next useful loop should let a learner:

1. Choose a specific practice path, such as interview answers or speaking confidence.
2. Work through 2-3 prompt turns in one session.
3. See feedback per turn and a stronger final summary.
4. Compare the current session with recent local history.

Suggested goals:

- Speaking confidence
- Interview answers
- Pronunciation awareness
- Vocabulary expansion
- Writing clarity

Suggested practice modes:

- Text response
- Speaking prompt placeholder
- Role-play prompt placeholder

## Self-prompt for the next coding step

Use this prompt to continue:

```text
Implement a deeper multi-turn coaching practice flow for Coach E.

Context:
- Read AGENTS.md, docs/coach_e_requirements.md, docs/stranger_confide_reuse_plan.md, and docs/project_state_and_next_prompt.md first.
- Do not integrate backend yet.
- Keep hardcoded/local auth as-is.
- Use the existing app shell, go_router, flutter_bloc, cyr_app_kit theme, completed CoachingCubit flow, and local session history.
- Follow package imports and flutter_lints.

Goal:
Make one coaching practice mode feel more complete by supporting multiple prompt turns before final feedback.

Requirements:
1. Pick one initial path, preferably Speaking confidence + Text response.
2. Add 2-3 deterministic prompt turns in one session.
3. Track each learner response locally inside the active session.
4. Generate per-turn placeholder feedback.
5. Generate a final summary that still saves to local history.
6. Keep reopen summary read-only.
7. Add focused widget tests for the multi-turn flow.
8. Run:
   - dart format .
   - flutter analyze
   - flutter test

Constraints:
- Do not add backend clients yet.
- Do not initialize Firebase yet.
- Do not add new dependencies unless clearly needed.
- Keep UI practical and coaching-focused, not a marketing landing page.
```

## Questions to ask the product owner later

- Should the first serious flow be speaking practice, writing correction, interview coaching, or mixed coaching?
- Should the first language mode be Vietnamese UI with English practice content, fully English, or bilingual?
- Should feedback be strict/corrective or warm/coaching-oriented by default?
