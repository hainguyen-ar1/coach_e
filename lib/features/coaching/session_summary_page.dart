import 'package:coach_e/features/coaching/cubit/coaching_history_cubit.dart';
import 'package:coach_e/features/coaching/models/coaching_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachingSessionSummaryPage extends StatelessWidget {
  const CoachingSessionSummaryPage({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CoachingHistoryCubit>().state;
    final session = _findSession(state.sessions, sessionId);

    return Scaffold(
      appBar: AppBar(title: const Text('Session summary')),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (session != null) {
              return _SummaryBody(session: session);
            }

            if (state.status == CoachingHistoryStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Không tìm thấy phiên coaching này.'),
              ),
            );
          },
        ),
      ),
    );
  }

  CoachingSessionSummary? _findSession(
    List<CoachingSessionSummary> sessions,
    String sessionId,
  ) {
    for (final session in sessions) {
      if (session.id == sessionId) return session;
    }
    return null;
  }
}

class _SummaryBody extends StatelessWidget {
  const _SummaryBody({required this.session});

  final CoachingSessionSummary session;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          session.goal.label,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text('${session.mode.label} • ${session.completedAtLabel}'),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.promptTitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(session.promptInstruction),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _ReadOnlySection(
          title: 'Learner response',
          child: Text(session.learnerResponse),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        session.feedbackHeadline,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    CircleAvatar(radius: 24, child: Text('${session.score}')),
                  ],
                ),
                const SizedBox(height: 14),
                _BulletList(title: 'Điểm mạnh', items: session.strengths),
                const SizedBox(height: 12),
                _BulletList(title: 'Cần chỉnh', items: session.improvements),
                const SizedBox(height: 12),
                Text(
                  'Next step',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(session.nextStep),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReadOnlySection extends StatelessWidget {
  const _ReadOnlySection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.title, required this.items});

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
