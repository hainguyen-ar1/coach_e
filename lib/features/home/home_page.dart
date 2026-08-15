import 'package:coach_e/core/auth/auth_cubit.dart';
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
              onPressed: () => context.go(AppRoutes.coaching),
            ),
            const SizedBox(height: 16),
            const _ActionPanel(
              icon: Icons.insights_outlined,
              title: 'Progress',
              subtitle: 'Sẽ dùng cho streak, kỹ năng yếu, lịch sử phiên học.',
              buttonLabel: 'Sắp có',
              onPressed: null,
            ),
          ],
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
