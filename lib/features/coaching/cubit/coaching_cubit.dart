import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:coach_e/features/coaching/models/coaching_models.dart';

enum CoachingStep { choosingGoal, choosingMode, drafting, feedback, summary }

class CoachingState {
  const CoachingState({
    required this.step,
    required this.draft,
    this.errorMessage,
  });

  const CoachingState.initial()
    : this(
        step: CoachingStep.choosingGoal,
        draft: const CoachingSessionDraft(),
      );

  final CoachingStep step;
  final CoachingSessionDraft draft;
  final String? errorMessage;

  bool get canSubmitResponse => draft.response.trim().length >= 12;

  CoachingState copyWith({
    CoachingStep? step,
    CoachingSessionDraft? draft,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CoachingState(
      step: step ?? this.step,
      draft: draft ?? this.draft,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class CoachingCubit extends Cubit<CoachingState> {
  CoachingCubit() : super(const CoachingState.initial());

  void selectGoal(CoachingGoal goal) {
    emit(
      state.copyWith(
        step: CoachingStep.choosingMode,
        draft: CoachingSessionDraft(goal: goal),
        clearError: true,
      ),
    );
  }

  void selectMode(PracticeMode mode) {
    final goal = state.draft.goal;
    if (goal == null) {
      emit(
        state.copyWith(
          step: CoachingStep.choosingGoal,
          errorMessage: 'Chọn mục tiêu trước khi chọn chế độ luyện tập.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        step: CoachingStep.drafting,
        draft: state.draft.copyWith(
          mode: mode,
          prompt: _promptFor(goal, mode),
          response: '',
          clearFeedback: true,
        ),
        clearError: true,
      ),
    );
  }

  void updateResponse(String value) {
    emit(
      state.copyWith(
        draft: state.draft.copyWith(response: value, clearFeedback: true),
        clearError: true,
      ),
    );
  }

  void submitResponse() {
    final goal = state.draft.goal;
    final mode = state.draft.mode;
    final response = state.draft.response.trim();

    if (goal == null || mode == null) {
      emit(
        state.copyWith(
          step: CoachingStep.choosingGoal,
          errorMessage: 'Bắt đầu bằng mục tiêu và chế độ luyện tập.',
        ),
      );
      return;
    }

    if (response.length < 12) {
      emit(
        state.copyWith(
          errorMessage: 'Viết ít nhất 12 ký tự để Coach E có thể phản hồi.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        step: CoachingStep.feedback,
        draft: state.draft.copyWith(
          response: response,
          feedback: _feedbackFor(goal, mode, response),
        ),
        clearError: true,
      ),
    );
  }

  void completeSession() {
    if (state.draft.feedback == null) return;
    emit(state.copyWith(step: CoachingStep.summary, clearError: true));
  }

  void backToGoal() {
    emit(const CoachingState.initial());
  }

  void backToMode() {
    final goal = state.draft.goal;
    if (goal == null) {
      emit(const CoachingState.initial());
      return;
    }

    emit(
      state.copyWith(
        step: CoachingStep.choosingMode,
        draft: CoachingSessionDraft(goal: goal),
        clearError: true,
      ),
    );
  }

  void reset() {
    emit(const CoachingState.initial());
  }

  CoachingPrompt _promptFor(CoachingGoal goal, PracticeMode mode) {
    final goalText = switch (goal) {
      CoachingGoal.speakingConfidence =>
        'Talk about a moment when you handled a difficult conversation.',
      CoachingGoal.interviewAnswers =>
        'Answer: Tell me about yourself and why this role fits you.',
      CoachingGoal.pronunciationAwareness =>
        'Prepare a clear answer using short sentences and natural pauses.',
      CoachingGoal.vocabularyExpansion =>
        'Explain a recent learning experience using three precise adjectives.',
      CoachingGoal.writingClarity =>
        'Rewrite an idea so the main point is obvious in the first sentence.',
    };

    final modeText = switch (mode) {
      PracticeMode.textResponse => 'Write 2-4 sentences.',
      PracticeMode.speakingPrompt => 'Draft what you would say out loud.',
      PracticeMode.rolePlay => 'Reply as if Coach E just asked you live.',
    };

    return CoachingPrompt(
      title: '${goal.label} practice',
      instruction: '$goalText $modeText',
      hint: 'Aim for one clear idea, one concrete detail, and one next action.',
    );
  }

  CoachingFeedback _feedbackFor(
    CoachingGoal goal,
    PracticeMode mode,
    String response,
  ) {
    final wordCount = response
        .split(RegExp(r'\s+'))
        .where((word) => word.trim().isNotEmpty)
        .length;
    final hasConcreteDetail = RegExp(
      r'\b(because|when|after|before|example|for example|last|next)\b',
      caseSensitive: false,
    ).hasMatch(response);
    final hasStructure = RegExp(
      r'\b(first|second|finally|but|so|therefore|however)\b',
      caseSensitive: false,
    ).hasMatch(response);

    final score = [
      if (wordCount >= 18) 30 else 18,
      if (hasConcreteDetail) 25 else 12,
      if (hasStructure) 25 else 12,
      if (response.length >= 120) 20 else 12,
    ].fold<int>(0, (sum, value) => sum + value);

    return CoachingFeedback(
      headline: 'Good start for ${goal.label.toLowerCase()}',
      score: score.clamp(0, 100),
      strengths: [
        if (wordCount >= 18)
          'Your answer has enough material to coach.'
        else
          'You kept the answer concise.',
        if (hasConcreteDetail)
          'You included a detail that makes the answer more believable.'
        else
          'The main idea is visible and ready to expand.',
        'The ${mode.label.toLowerCase()} format is clear.',
      ],
      improvements: [
        if (!hasConcreteDetail)
          'Add one specific example using “when” or “because”.',
        if (!hasStructure)
          'Use a simple connector like “first”, “so”, or “however”.',
        if (wordCount < 18)
          'Add one more sentence with a result or lesson learned.',
      ],
      nextStep:
          'Revise once by adding a concrete detail, then read it out loud slowly.',
    );
  }
}
