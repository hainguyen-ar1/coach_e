import 'package:coach_e/features/coaching/cubit/coaching_cubit.dart';
import 'package:coach_e/features/coaching/cubit/coaching_history_cubit.dart';
import 'package:coach_e/features/coaching/models/coaching_models.dart';
import 'package:coach_e/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CoachingPage extends StatefulWidget {
  const CoachingPage({super.key});

  @override
  State<CoachingPage> createState() => _CoachingPageState();
}

class _CoachingPageState extends State<CoachingPage> {
  final _responseController = TextEditingController();

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoachingCubit, CoachingState>(
      listenWhen: (previous, current) =>
          previous.draft.response != current.draft.response ||
          previous.draft.currentTurnIndex != current.draft.currentTurnIndex,
      listener: (context, state) {
        if (_responseController.text == state.draft.response) return;
        _responseController.text = state.draft.response;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Coaching'),
          actions: [
            IconButton(
              tooltip: 'Bắt đầu lại',
              onPressed: () {
                _responseController.clear();
                context.read<CoachingCubit>().reset();
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<CoachingCubit, CoachingState>(
            builder: (context, state) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const _Header(),
                  const SizedBox(height: 18),
                  _ProgressRail(step: state.step),
                  const SizedBox(height: 20),
                  if (state.errorMessage case final message?)
                    _InlineError(message: message),
                  _GoalPicker(state: state),
                  if (state.draft.goal != null) ...[
                    const SizedBox(height: 18),
                    _ModePicker(state: state),
                  ],
                  if (state.draft.prompt != null) ...[
                    const SizedBox(height: 18),
                    _PromptAndResponse(
                      state: state,
                      controller: _responseController,
                    ),
                  ],
                  if (state.draft.feedback != null) ...[
                    const SizedBox(height: 18),
                    _FeedbackPanel(state: state),
                  ],
                  if (state.step == CoachingStep.summary) ...[
                    const SizedBox(height: 18),
                    _SummaryPanel(state: state),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phiên coaching đầu tiên',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Chọn mục tiêu, luyện một phản hồi ngắn, rồi nhận feedback local để chỉnh ngay.',
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _ProgressRail extends StatelessWidget {
  const _ProgressRail({required this.step});

  final CoachingStep step;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentIndex = CoachingStep.values.indexOf(step);
    const labels = ['Goal', 'Mode', 'Draft', 'Feedback', 'Summary'];

    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 6,
              decoration: BoxDecoration(
                color: index <= currentIndex
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          if (index < labels.length - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

class _GoalPicker extends StatelessWidget {
  const _GoalPicker({required this.state});

  final CoachingState state;

  @override
  Widget build(BuildContext context) {
    final selectedGoal = state.draft.goal;

    return _Section(
      title: '1. Chọn mục tiêu',
      trailing: selectedGoal == null ? null : 'Đã chọn: ${selectedGoal.label}',
      child: Column(
        children: [
          for (final goal in CoachingGoal.values)
            _ChoiceTile(
              icon: _goalIcon(goal),
              title: goal.label,
              body: goal.description,
              selected: selectedGoal == goal,
              onTap: () => context.read<CoachingCubit>().selectGoal(goal),
            ),
        ],
      ),
    );
  }

  IconData _goalIcon(CoachingGoal goal) {
    return switch (goal) {
      CoachingGoal.speakingConfidence => Icons.record_voice_over_outlined,
      CoachingGoal.interviewAnswers => Icons.work_outline,
      CoachingGoal.pronunciationAwareness => Icons.hearing_outlined,
      CoachingGoal.vocabularyExpansion => Icons.auto_stories_outlined,
      CoachingGoal.writingClarity => Icons.edit_note_outlined,
    };
  }
}

class _ModePicker extends StatelessWidget {
  const _ModePicker({required this.state});

  final CoachingState state;

  @override
  Widget build(BuildContext context) {
    final selectedMode = state.draft.mode;

    return _Section(
      title: '2. Chọn chế độ luyện tập',
      child: Column(
        children: [
          for (final mode in PracticeMode.values)
            _ChoiceTile(
              icon: _modeIcon(mode),
              title: mode.label,
              body: mode.description,
              selected: selectedMode == mode,
              onTap: () => context.read<CoachingCubit>().selectMode(mode),
            ),
        ],
      ),
    );
  }

  IconData _modeIcon(PracticeMode mode) {
    return switch (mode) {
      PracticeMode.textResponse => Icons.keyboard_alt_outlined,
      PracticeMode.speakingPrompt => Icons.mic_none_outlined,
      PracticeMode.rolePlay => Icons.forum_outlined,
    };
  }
}

class _PromptAndResponse extends StatelessWidget {
  const _PromptAndResponse({required this.state, required this.controller});

  final CoachingState state;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final prompt = state.draft.prompt!;
    final textTheme = Theme.of(context).textTheme;

    return _Section(
      title: '3. Luyện phản hồi',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prompt.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(prompt.instruction),
                  const SizedBox(height: 10),
                  Text(
                    prompt.hint,
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            minLines: 5,
            maxLines: 8,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              labelText: 'Câu trả lời của bạn',
              hintText: 'Ví dụ: First, I would explain the situation...',
              prefixIcon: Icon(Icons.edit_outlined),
            ),
            onChanged: context.read<CoachingCubit>().updateResponse,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    controller.clear();
                    context.read<CoachingCubit>().backToMode();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Đổi mode'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: state.canSubmitResponse
                      ? context.read<CoachingCubit>().submitResponse
                      : null,
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text('Nhận feedback'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  const _FeedbackPanel({required this.state});

  final CoachingState state;

  @override
  Widget build(BuildContext context) {
    final feedback = state.draft.feedback!;
    final textTheme = Theme.of(context).textTheme;

    return _Section(
      title: '4. Feedback',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      feedback.headline,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  CircleAvatar(radius: 24, child: Text('${feedback.score}')),
                ],
              ),
              const SizedBox(height: 14),
              _FeedbackList(title: 'Điểm mạnh', items: feedback.strengths),
              const SizedBox(height: 12),
              _FeedbackList(title: 'Cần chỉnh', items: feedback.improvements),
              const SizedBox(height: 12),
              Text(
                'Next step',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(feedback.nextStep),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: context.read<CoachingCubit>().submitResponse,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Chấm lại'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: state.canContinueToNextTurn
                        ? FilledButton.icon(
                            onPressed: () {
                              context
                                  .read<CoachingCubit>()
                                  .continueToNextTurn();
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Lượt tiếp theo'),
                          )
                        : FilledButton.icon(
                            onPressed: state.canCompleteSession
                                ? () => context
                                      .read<CoachingCubit>()
                                      .completeSession(
                                        saveSession: context
                                            .read<CoachingHistoryCubit>()
                                            .saveCompletedDraft,
                                      )
                                : null,
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(
                              state.isCompleting ? 'Đang lưu' : 'Hoàn tất',
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.state});

  final CoachingState state;

  @override
  Widget build(BuildContext context) {
    final draft = state.draft;
    final textTheme = Theme.of(context).textTheme;

    return _Section(
      title: '5. Summary',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phiên luyện tập đã xong',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text('Goal: ${draft.goal?.label ?? '-'}'),
              Text('Mode: ${draft.mode?.label ?? '-'}'),
              Text('Score: ${draft.feedback?.score ?? 0}/100'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => GoRouter.of(context).go(AppRoutes.home),
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Về Home'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: context.read<CoachingCubit>().reset,
                      icon: const Icon(Icons.play_arrow_outlined),
                      label: const Text('Phiên mới'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackList extends StatelessWidget {
  const _FeedbackList({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(item)),
              ],
            ),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (trailing != null)
              Flexible(
                child: Text(
                  trailing!,
                  textAlign: TextAlign.right,
                  style: textTheme.bodySmall,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected
            ? colorScheme.primary.withValues(alpha: 0.12)
            : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
            width: selected ? 1.4 : 0.8,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(body),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? colorScheme.primary : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: colorScheme.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: colorScheme.error),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }
}
