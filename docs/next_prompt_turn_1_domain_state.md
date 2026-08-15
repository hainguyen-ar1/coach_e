# Next Prompt Turn 1 - Multi-Turn Coaching Domain And State

Use this prompt for the first coding turn.

```text
Implement the domain/state foundation for a multi-turn Coach E coaching session.

Context:
- Read AGENTS.md, docs/coach_e_requirements.md, docs/stranger_confide_reuse_plan.md, and docs/project_state_and_next_prompt.md first.
- Coach E is a Flutter mobile app.
- Do not integrate backend yet.
- Keep hardcoded/local auth as-is.
- Use existing patterns in:
  - lib/features/coaching/models/coaching_models.dart
  - lib/features/coaching/cubit/coaching_cubit.dart
  - lib/features/coaching/data/coaching_history_repository.dart
  - lib/features/coaching/cubit/coaching_history_cubit.dart
- Follow package imports and flutter_lints.

Goal:
Prepare the coaching feature to support a 3-turn local-only practice session
instead of a single prompt/response.

Requirements:
1. Focus the initial deeper flow on Speaking confidence + Text response.
2. Add model support for coaching turns. Each turn should store:
   - turn index
   - prompt title
   - prompt instruction
   - prompt hint
   - learner response
   - placeholder feedback headline
   - strengths
   - improvements
   - next step
   - score
3. Add 3 deterministic prompt turns:
   - warm-up answer
   - concrete example
   - improved final version
4. Update CoachingCubit/CoachingState so an active session can:
   - start with selected goal and mode
   - know the current turn
   - accept response text for the current turn
   - prevent submit when the response is too short
   - generate deterministic feedback for the submitted turn
   - move to the next turn after feedback
   - generate final summary after all turns are complete
5. Preserve existing single-session behavior where possible while migrating the
   app toward multi-turn state.
6. Keep completed session history local-only through shared_preferences.
7. Do not change the UI deeply in this turn unless needed for compilation.
8. Keep old saved one-turn summaries from crashing the app. If schema migration
   is too large for this turn, handle old entries gracefully by ignoring invalid
   local records or mapping them to one turn.

Constraints:
- Do not add backend clients.
- Do not initialize Firebase.
- Do not add new dependencies unless clearly needed.
- Keep code small and aligned with the existing Cubit style.

Verification:
- Run dart format .
- Run flutter analyze.
- If widget tests fail because the UI still expects old state, make the minimum
  compatibility update needed or leave a clear note in docs/project_state_and_next_prompt.md.
```

