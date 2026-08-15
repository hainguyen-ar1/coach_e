import 'package:flutter/material.dart';

class CoachingPage extends StatelessWidget {
  const CoachingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Coaching')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Phiên coaching đầu tiên',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Màn này là điểm neo để phát triển tính năng coaching trước khi backend sẵn sàng.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CoachStep(
              icon: Icons.flag_outlined,
              title: 'Goal',
              body: 'Chọn mục tiêu: phản xạ, phát âm, phỏng vấn, thuyết trình.',
            ),
            const _CoachStep(
              icon: Icons.mic_none_outlined,
              title: 'Practice',
              body: 'Ghi âm hoặc nhập câu trả lời để coach phân tích.',
            ),
            const _CoachStep(
              icon: Icons.rate_review_outlined,
              title: 'Feedback',
              body: 'Nhận nhận xét, sửa câu, và bài tập tiếp theo.',
            ),
          ],
        ),
      ),
    );
  }
}

class _CoachStep extends StatelessWidget {
  const _CoachStep({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 14),
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
                    const SizedBox(height: 6),
                    Text(body),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
