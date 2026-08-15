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

class CoachingTurn {
  const CoachingTurn({
    required this.index,
    required this.prompt,
    this.response = '',
    this.feedback,
  });

  factory CoachingTurn.fromJson(Map<String, dynamic> json) {
    return CoachingTurn(
      index: json['index'] as int,
      prompt: CoachingPrompt(
        title: json['promptTitle'] as String,
        instruction: json['promptInstruction'] as String,
        hint: json['promptHint'] as String? ?? '',
      ),
      response: json['learnerResponse'] as String? ?? '',
      feedback: json['feedbackHeadline'] == null
          ? null
          : CoachingFeedback(
              headline: json['feedbackHeadline'] as String,
              strengths: List<String>.unmodifiable(
                (json['strengths'] as List<dynamic>? ?? const [])
                    .cast<String>(),
              ),
              improvements: List<String>.unmodifiable(
                (json['improvements'] as List<dynamic>? ?? const [])
                    .cast<String>(),
              ),
              nextStep: json['nextStep'] as String? ?? '',
              score: json['score'] as int? ?? 0,
            ),
    );
  }

  final int index;
  final CoachingPrompt prompt;
  final String response;
  final CoachingFeedback? feedback;

  bool get isComplete => response.trim().isNotEmpty && feedback != null;

  CoachingTurn copyWith({
    CoachingPrompt? prompt,
    String? response,
    CoachingFeedback? feedback,
    bool clearFeedback = false,
  }) {
    return CoachingTurn(
      index: index,
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
      feedback: clearFeedback ? null : feedback ?? this.feedback,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'promptTitle': prompt.title,
      'promptInstruction': prompt.instruction,
      'promptHint': prompt.hint,
      'learnerResponse': response,
      'feedbackHeadline': feedback?.headline,
      'strengths': feedback?.strengths ?? const [],
      'improvements': feedback?.improvements ?? const [],
      'nextStep': feedback?.nextStep,
      'score': feedback?.score,
    };
  }
}

class CoachingSessionDraft {
  const CoachingSessionDraft({
    this.goal,
    this.mode,
    this.prompt,
    this.response = '',
    this.feedback,
    this.turns = const [],
    this.currentTurnIndex = 0,
  });

  final CoachingGoal? goal;
  final PracticeMode? mode;
  final CoachingPrompt? prompt;
  final String response;
  final CoachingFeedback? feedback;
  final List<CoachingTurn> turns;
  final int currentTurnIndex;

  CoachingTurn? get currentTurn {
    if (turns.isEmpty ||
        currentTurnIndex < 0 ||
        currentTurnIndex >= turns.length) {
      return null;
    }
    return turns[currentTurnIndex];
  }

  bool get hasMultiTurnSession => turns.isNotEmpty;
  bool get isOnLastTurn =>
      turns.isEmpty || currentTurnIndex == turns.length - 1;
  bool get allTurnsComplete =>
      turns.isNotEmpty && turns.every((turn) => turn.isComplete);

  CoachingSessionDraft copyWith({
    CoachingGoal? goal,
    PracticeMode? mode,
    CoachingPrompt? prompt,
    String? response,
    CoachingFeedback? feedback,
    List<CoachingTurn>? turns,
    int? currentTurnIndex,
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
      turns: turns ?? this.turns,
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
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
    this.turns = const [],
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
    final turns = draft.turns.isEmpty
        ? [
            CoachingTurn(
              index: 0,
              prompt: prompt,
              response: draft.response.trim(),
              feedback: feedback,
            ),
          ]
        : draft.turns;
    final completedTurns = turns
        .where((turn) => turn.feedback != null)
        .toList();
    final score = completedTurns.isEmpty
        ? feedback.score
        : (completedTurns
                      .map((turn) => turn.feedback?.score ?? 0)
                      .fold<int>(0, (sum, value) => sum + value) /
                  completedTurns.length)
              .round();

    return CoachingSessionSummary(
      id: 'session-${finishedAt.microsecondsSinceEpoch}',
      completedAt: finishedAt,
      goal: goal,
      mode: mode,
      promptTitle: prompt.title,
      promptInstruction: prompt.instruction,
      learnerResponse: draft.response.trim(),
      feedbackHeadline: draft.turns.isEmpty
          ? feedback.headline
          : 'Completed ${completedTurns.length}-turn ${goal.label.toLowerCase()} practice',
      strengths: List<String>.unmodifiable(
        _mergeFeedbackItems(completedTurns, true),
      ),
      improvements: List<String>.unmodifiable(
        _mergeFeedbackItems(completedTurns, false),
      ),
      nextStep: completedTurns.isEmpty
          ? feedback.nextStep
          : completedTurns.last.feedback?.nextStep ?? feedback.nextStep,
      score: score,
      turns: List<CoachingTurn>.unmodifiable(turns),
    );
  }

  factory CoachingSessionSummary.fromJson(Map<String, dynamic> json) {
    final goal = _enumByName(CoachingGoal.values, json['goal']);
    final mode = _enumByName(PracticeMode.values, json['mode']);
    if (goal == null || mode == null) {
      throw const FormatException('Unknown coaching goal or practice mode.');
    }

    final turnsJson = json['turns'];
    final turns = turnsJson is List
        ? List<CoachingTurn>.unmodifiable(
            turnsJson.whereType<Map<String, dynamic>>().map(
              CoachingTurn.fromJson,
            ),
          )
        : const <CoachingTurn>[];

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
      turns: turns,
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
  final List<CoachingTurn> turns;

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
      'turns': [for (final turn in turns) turn.toJson()],
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

  static List<String> _mergeFeedbackItems(
    List<CoachingTurn> completedTurns,
    bool strengths,
  ) {
    final items = <String>[];
    for (final turn in completedTurns) {
      final feedback = turn.feedback;
      if (feedback == null) continue;
      items.addAll(strengths ? feedback.strengths : feedback.improvements);
    }
    return items.isEmpty
        ? strengths
              ? const ['You completed the practice session.']
              : const ['Keep adding concrete details in the next practice.']
        : items.toSet().take(4).toList();
  }
}
