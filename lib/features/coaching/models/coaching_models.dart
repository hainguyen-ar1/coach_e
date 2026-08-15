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

class CoachingSessionSummary {
  const CoachingSessionSummary({
    required this.id,
    required this.completedAt,
    required this.goal,
    required this.mode,
    required this.promptTitle,
    required this.promptInstruction,
    required this.learnerResponse,
    required this.feedbackHeadline,
    required this.strengths,
    required this.improvements,
    required this.nextStep,
    required this.score,
  });

  factory CoachingSessionSummary.fromDraft(
    CoachingSessionDraft draft, {
    DateTime? completedAt,
  }) {
    final goal = draft.goal;
    final mode = draft.mode;
    final prompt = draft.prompt;
    final feedback = draft.feedback;
    if (goal == null || mode == null || prompt == null || feedback == null) {
      throw ArgumentError('Cannot summarize an incomplete coaching session.');
    }

    final finishedAt = completedAt ?? DateTime.now();
    return CoachingSessionSummary(
      id: 'session-${finishedAt.microsecondsSinceEpoch}',
      completedAt: finishedAt,
      goal: goal,
      mode: mode,
      promptTitle: prompt.title,
      promptInstruction: prompt.instruction,
      learnerResponse: draft.response.trim(),
      feedbackHeadline: feedback.headline,
      strengths: List<String>.unmodifiable(feedback.strengths),
      improvements: List<String>.unmodifiable(feedback.improvements),
      nextStep: feedback.nextStep,
      score: feedback.score,
    );
  }

  factory CoachingSessionSummary.fromJson(Map<String, dynamic> json) {
    final goal = _enumByName(CoachingGoal.values, json['goal']);
    final mode = _enumByName(PracticeMode.values, json['mode']);
    if (goal == null || mode == null) {
      throw const FormatException('Unknown coaching goal or practice mode.');
    }

    return CoachingSessionSummary(
      id: json['id'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      goal: goal,
      mode: mode,
      promptTitle: json['promptTitle'] as String,
      promptInstruction: json['promptInstruction'] as String,
      learnerResponse: json['learnerResponse'] as String,
      feedbackHeadline: json['feedbackHeadline'] as String,
      strengths: List<String>.unmodifiable(
        (json['strengths'] as List<dynamic>).cast<String>(),
      ),
      improvements: List<String>.unmodifiable(
        (json['improvements'] as List<dynamic>).cast<String>(),
      ),
      nextStep: json['nextStep'] as String,
      score: json['score'] as int,
    );
  }

  final String id;
  final DateTime completedAt;
  final CoachingGoal goal;
  final PracticeMode mode;
  final String promptTitle;
  final String promptInstruction;
  final String learnerResponse;
  final String feedbackHeadline;
  final List<String> strengths;
  final List<String> improvements;
  final String nextStep;
  final int score;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'completedAt': completedAt.toIso8601String(),
      'goal': goal.name,
      'mode': mode.name,
      'promptTitle': promptTitle,
      'promptInstruction': promptInstruction,
      'learnerResponse': learnerResponse,
      'feedbackHeadline': feedbackHeadline,
      'strengths': strengths,
      'improvements': improvements,
      'nextStep': nextStep,
      'score': score,
    };
  }

  String get completedAtLabel {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${completedAt.year}-'
        '${twoDigits(completedAt.month)}-'
        '${twoDigits(completedAt.day)} '
        '${twoDigits(completedAt.hour)}:'
        '${twoDigits(completedAt.minute)}';
  }

  static T? _enumByName<T extends Enum>(List<T> values, Object? name) {
    if (name is! String) return null;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}
