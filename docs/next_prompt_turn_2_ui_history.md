# Next Prompt Turn 2 - Multi-Turn Coaching UI And History

Use this prompt after Turn 1 has completed.

```text
Implement the UI and read-only history experience for Coach E's multi-turn
coaching practice flow.

Context:
- Read AGENTS.md, docs/coach_e_requirements.md, docs/stranger_confide_reuse_plan.md, docs/project_state_and_next_prompt.md, and docs/next_prompt_turn_1_domain_state.md first.
- Do not integrate backend yet.
- Keep hardcoded/local auth as-is.
- Use the multi-turn state/model work from Turn 1.
- Main files likely involved:
  - lib/features/coaching/coaching_page.dart
  - lib/features/coaching/session_summary_page.dart
  - lib/features/home/home_page.dart
  - lib/features/coaching/models/coaching_models.dart
  - lib/features/coaching/cubit/coaching_cubit.dart
  - lib/features/coaching/cubit/coaching_history_cubit.dart
  - lib/features/coaching/data/coaching_history_repository.dart

Goal:
Make the learner-facing flow feel complete for a 3-turn local-only coaching
session, and make saved multi-turn summaries readable from Home.

Requirements:
1. Update /coaching so the learner can complete 3 turns:
   - warm-up answer
   - concrete example
   - improved final version
2. Show clear progress through the turns without making the screen feel like a
   marketing page.
3. For each turn:
   - show the prompt
   - accept the learner response
   - disable submit until the response has enough content
   - show per-turn placeholder feedback after submit
   - let the learner continue to the next turn
4. After the last turn, show a final summary with:
   - overall score
   - combined strengths
   - combined improvements
   - next step
   - all turn responses
5. Save the completed session to existing local history.
6. Update Home recent sessions only as needed:
   - keep the list compact
   - show goal, mode, score, and completed time
   - keep clear-history behavior
7. Update session_summary_page.dart so reopened summaries are read-only and show
   all multi-turn details.
8. Keep old saved data from breaking the page. If old records are ignored,
   make that behavior intentional and documented in code or docs.

Constraints:
- Do not add backend clients.
- Do not initialize Firebase.
- Do not add new dependencies unless clearly needed.
- Keep UI practical, coaching-focused, and consistent with the existing app.
- Avoid large unrelated refactors.

Verification:
- Run dart format .
- Run flutter analyze.
- Run flutter test.
- If tests need updating because the flow changed from one turn to three turns,
  update them in the next prompt turn instead of leaving the repo broken.
```

