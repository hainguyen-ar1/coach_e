enum CoachingGoal {
  speakingConfidence,
  interviewAnswers,
  pronunciationAwareness,
  vocabularyExpansion,
  writingClarity,
}

extension CoachingGoalLabel on CoachingGoal {
  String get label {
    return switch (this) {
      CoachingGoal.speakingConfidence => 'Speaking confidence',
      CoachingGoal.interviewAnswers => 'Interview answers',
      CoachingGoal.pronunciationAwareness => 'Pronunciation awareness',
      CoachingGoal.vocabularyExpansion => 'Vocabulary expansion',
      CoachingGoal.writingClarity => 'Writing clarity',
    };
  }

  String get description {
    return switch (this) {
      CoachingGoal.speakingConfidence =>
        'Build calmer, more natural English responses.',
      CoachingGoal.interviewAnswers =>
        'Shape answers that are structured and specific.',
      CoachingGoal.pronunciationAwareness =>
        'Notice rhythm, stress, and clarity before recording arrives.',
      CoachingGoal.vocabularyExpansion =>
        'Stretch word choice without sounding forced.',
      CoachingGoal.writingClarity =>
        'Make ideas easier to follow in written English.',
    };
  }
}

enum PracticeMode { textResponse, speakingPrompt, rolePlay }

extension PracticeModeLabel on PracticeMode {
  String get label {
    return switch (this) {
      PracticeMode.textResponse => 'Text response',
      PracticeMode.speakingPrompt => 'Speaking prompt',
      PracticeMode.rolePlay => 'Role-play',
    };
  }

  String get description {
    return switch (this) {
      PracticeMode.textResponse => 'Write a concise answer and refine it.',
      PracticeMode.speakingPrompt =>
        'Prepare a spoken answer before recording.',
      PracticeMode.rolePlay => 'Respond as if you are in a live conversation.',
    };
  }
}

class CoachingPrompt {
  const CoachingPrompt({
    required this.title,
    required this.instruction,
    required this.hint,
  });

  final String title;
  final String instruction;
  final String hint;
}

class CoachingFeedback {
  const CoachingFeedback({
    required this.headline,
    required this.strengths,
    required this.improvements,
    required this.nextStep,
    required this.score,
  });

  final String headline;
  final List<String> strengths;
  final List<String> improvements;
  final String nextStep;
  final int score;
}

class CoachingSessionDraft {
  const CoachingSessionDraft({
    this.goal,
    this.mode,
    this.prompt,
    this.response = '',
    this.feedback,
  });

  final CoachingGoal? goal;
  final PracticeMode? mode;
  final CoachingPrompt? prompt;
  final String response;
  final CoachingFeedback? feedback;

  CoachingSessionDraft copyWith({
    CoachingGoal? goal,
    PracticeMode? mode,
    CoachingPrompt? prompt,
    String? response,
    CoachingFeedback? feedback,
    bool clearMode = false,
    bool clearPrompt = false,
    bool clearFeedback = false,
  }) {
    return CoachingSessionDraft(
      goal: goal ?? this.goal,
      mode: clearMode ? null : mode ?? this.mode,
      prompt: clearPrompt ? null : prompt ?? this.prompt,
      response: response ?? this.response,
      feedback: clearFeedback ? null : feedback ?? this.feedback,
    );
  }
}
