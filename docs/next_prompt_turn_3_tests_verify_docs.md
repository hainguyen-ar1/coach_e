# Next Prompt Turn 3 - Tests, Verification, And Docs

Use this prompt after Turns 1 and 2 have completed.

```text
Finish the multi-turn Coach E coaching feature with focused tests,
verification, and documentation updates.

Context:
- Read AGENTS.md, docs/coach_e_requirements.md, docs/stranger_confide_reuse_plan.md, docs/project_state_and_next_prompt.md, docs/next_prompt_turn_1_domain_state.md, and docs/next_prompt_turn_2_ui_history.md first.
- Do not integrate backend yet.
- Keep hardcoded/local auth as-is.
- The app should now support a 3-turn local coaching session.
- Main files likely involved:
  - test/widget_test.dart
  - docs/project_state_and_next_prompt.md
  - lib/features/coaching/*
  - lib/features/home/home_page.dart

Goal:
Make sure the multi-turn local coaching flow is tested, verified, and reflected
accurately in project documentation.

Requirements:
1. Add or update widget tests for:
   - opening demo Home
   - starting a coaching session
   - completing all 3 turns
   - seeing per-turn feedback
   - saving the final summary
   - returning Home and reopening the read-only summary
   - clearing local history
2. Add a focused test for too-short response behavior:
   - submit should stay disabled or show the expected validation state
   - the learner should not advance to the next turn
3. If practical, add model/repository tests for:
   - serializing a multi-turn session summary
   - loading old or malformed local history without crashing
4. Update docs/project_state_and_next_prompt.md:
   - mark multi-turn coaching as completed if it works
   - move any remaining gaps into "What is still missing"
   - replace the next prompt with the next useful feature slice
5. Recommend the next feature slice after multi-turn local coaching. Good options:
   - resumable in-progress local drafts
   - audio recording placeholder flow
   - i18n asset wiring
   - backend-ready coaching API contract draft

Verification:
Run these commands and fix issues:
- dart format .
- flutter analyze
- flutter test
- git diff --check

Constraints:
- Do not add backend clients.
- Do not initialize Firebase.
- Do not add new dependencies unless clearly needed.
- Keep docs concise and useful for the next agent.
```

