import 'package:coach_e/core/auth/auth_cubit.dart';
import 'package:coach_e/features/coaching/cubit/coaching_history_cubit.dart';
import 'package:coach_e/features/coaching/models/coaching_models.dart';
import 'package:coach_e/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthCubit, CoachUser?>(
      (cubit) => cubit.state.user,
    );
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach E'),
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            onPressed: () => context.read<AuthCubit>().signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Xin chào, ${user?.name ?? 'Learner'}',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Trọng tâm hôm nay: ${user?.focus ?? 'coaching'}',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _ActionPanel(
              icon: Icons.record_voice_over_outlined,
              title: 'Coaching session',
              subtitle:
                  'Khung luyện tập đầu tiên cho bài nói, phản hồi và mục tiêu.',
              buttonLabel: 'Mở coaching',
              onPressed: () => GoRouter.of(context).go(AppRoutes.coaching),
            ),
            const SizedBox(height: 16),
            const _RecentSessionsSection(),
          ],
        ),
      ),
    );
  }
}

class _RecentSessionsSection extends StatelessWidget {
  const _RecentSessionsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoachingHistoryCubit, CoachingHistoryState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.insights_outlined, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Recent sessions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (state.sessions.isNotEmpty)
                      TextButton.icon(
                        onPressed: () =>
                            context.read<CoachingHistoryCubit>().clearHistory(),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear history'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (state.status == CoachingHistoryStatus.loading)
                  const LinearProgressIndicator()
                else if (state.sessions.isEmpty)
                  const Text(
                    'No sessions yet. Complete one coaching session to start tracking practice.',
                  )
                else ...[
                  for (final session in state.sessions.take(5))
                    _RecentSessionTile(session: session),
                ],
                if (state.errorMessage case final message?) ...[
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecentSessionTile extends StatelessWidget {
  const _RecentSessionTile({required this.session});

  final CoachingSessionSummary session;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: ListTile(
          leading: CircleAvatar(child: Text('${session.score}')),
          title: Text(session.goal.label),
          subtitle: Text('${session.mode.label} • ${session.completedAtLabel}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => GoRouter.of(
            context,
          ).go(AppRoutes.coachingHistorySession(session.id)),
        ),
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  const _ActionPanel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 14),
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 18),
            FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
          ],
        ),
      ),
    );
  }
}
