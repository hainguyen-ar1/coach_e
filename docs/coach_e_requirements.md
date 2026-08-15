# Coach E Requirements Notes

Updated: 2026-08-15

## Current project state

`coach_e` is a fresh Flutter project that will use the reusable Flutter architecture from Stranger Confide, but it will not reuse the Stranger Confide backend. A separate Coach E backend will be created later.

## Confirmed product decisions

- `coach_e` will not use the Stranger Confide backend/API directly.
- The app may depend on local packages:
  - `/Users/hainguyen/dev/cyr_flutter_core`
  - `/Users/hainguyen/dev/talkfirst/cyr_app_kit`
- The first milestone is app shell plus hardcoded auth.
- Auth is temporary and local-only for now.
- Product development should prioritize coaching features before backend integration.

## Reference project reviewed

Reference path:

`/Users/hainguyen/dev/talkfirst/stranger_confide`

Relevant documents reviewed:

- `README.md`
- `AGENTS.md`
- `.cursor/rules/rules_10k.md`
- `handbook/mobile-matchmaking-chat-sync.md`
- `docs/MOBILE_CHAT_SPEC.md`
- `docs/api/api-index.md`
- Selected API domain docs: `common.md`, `matchmaking.md`, `rooms.md`

## Requirements inferred from the reference

The reference app is a Flutter mobile app for anonymous one-to-one realtime chat. For `coach_e`, reuse the mobile architecture and app foundation patterns, not the chat product domain by default.

Reference capabilities that may still be useful later:

- Authentication with email/password and social login.
- Profile creation and completion before matchmaking.
- Matchmaking queue with gender/preference matching.
- Realtime chat rooms over Socket.IO.
- REST fallbacks for room leave, image upload, status checks, and reporting.
- Anonymous session UI that exposes alias/avatar, not raw user identity.
- Moderation-aware send flow, especially no optimistic text messages.
- Blocking/reporting flows.
- Push notification handoff into an active chat room.
- App resume recovery through backend truth, especially `GET /api/rooms/active`.

## Functional build order

Recommended order for Coach E:

1. App shell: dependencies, routing, shared theme, auth state, splash/login/home.
2. Hardcoded auth: local-only login/demo session to unblock feature development.
3. Coaching foundation: coaching home, goal selection, practice session placeholder, feedback placeholder.
4. Local coaching state: session draft/progress without backend.
5. Backend-ready contracts: define Coach E auth/session/coaching API once backend begins.
6. Real auth integration: token storage, refresh, profile, session-expired routing.
7. Product polish: localization, empty/error states, accessibility, tests.

## Behavioral invariants to preserve if realtime/chat patterns are reused

- Register socket listeners before connecting.
- On chat reconnect, always emit `room:join` again to receive session/history.
- Chat disconnect does not close a room.
- Matchmaking disconnect removes the user from the queue immediately.
- On app resume, check `GET /api/rooms/active` before trusting local state.
- Do not add sent text locally before server broadcasts `chat:message`.
- Use `partnerUserId` only for report/block; never display it.
- Treat `room:closed` as terminal and different from `room:access_denied`.
- Switch chat socket errors by stable `code`; use `message` only for display.

## Resolved product questions

- Coach E is a coaching product using selected Stranger Confide architecture.
- Coach E will have its own backend later.
- Local packages `cyr_flutter_core` and `cyr_app_kit` are allowed.
- First milestone is app shell plus hardcoded auth.

## Remaining questions

- What are the first coaching workflows: speaking practice, writing correction, interview coaching, vocabulary drills, or a mixed session?
- Should the initial UX be Vietnamese-first, English-first, or bilingual?
