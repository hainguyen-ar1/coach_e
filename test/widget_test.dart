import 'package:coach_e/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const learnerResponses = [
    'First, I explain the context because it helps me sound calm and clear.',
    'When the conversation became difficult, I paused because I wanted to answer with care.',
    'First, I would explain the situation calmly, then share one example because it shows my communication style.',
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('completing a session saves and reopens a summary', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openDemoHome(tester);
    await _completeCoachingSession(tester, learnerResponses);

    await _scrollToText(tester, 'Về Home');
    await tester.tap(find.text('Về Home'));
    await tester.pumpAndSettle();

    expect(find.text('Recent sessions'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    expect(find.text('Session summary'), findsOneWidget);
    expect(find.text('Learner response'), findsOneWidget);
    expect(find.text(learnerResponses.last), findsOneWidget);
    expect(
      find.text('Completed 3-turn speaking confidence practice'),
      findsOneWidget,
    );
  });

  testWidgets('clear history removes recent sessions from Home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openDemoHome(tester);
    await _completeCoachingSession(tester, learnerResponses);

    await _scrollToText(tester, 'Về Home');
    await tester.tap(find.text('Về Home'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.text('Clear history'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.chevron_right), findsNothing);
    expect(
      find.text(
        'No sessions yet. Complete one coaching session to start tracking practice.',
      ),
      findsOneWidget,
    );
  });
}

Future<void> _openDemoHome(WidgetTester tester) async {
  await tester.pumpWidget(const CoachEApp());
  expect(find.text('Coach E'), findsOneWidget);

  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
  expect(find.text('Vào nhanh bản demo'), findsOneWidget);

  await tester.tap(find.text('Vào nhanh bản demo'));
  await tester.pumpAndSettle();
  expect(find.text('Coaching session'), findsOneWidget);
}

Future<void> _completeCoachingSession(
  WidgetTester tester,
  List<String> learnerResponses,
) async {
  await tester.tap(find.text('Mở coaching'));
  await tester.pumpAndSettle();
  expect(find.text('Phiên coaching đầu tiên'), findsOneWidget);

  await tester.ensureVisible(find.text('Speaking confidence'));
  await tester.tap(find.text('Speaking confidence'));
  await tester.pumpAndSettle();
  expect(find.text('2. Chọn chế độ luyện tập'), findsOneWidget);

  await tester.ensureVisible(find.text('Text response'));
  await tester.tap(find.text('Text response'));
  await tester.pumpAndSettle();
  expect(find.text('3. Luyện phản hồi'), findsOneWidget);

  for (var index = 0; index < learnerResponses.length; index++) {
    await tester.ensureVisible(find.byType(EditableText));
    await tester.enterText(find.byType(EditableText), learnerResponses[index]);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Nhận feedback'));
    await tester.tap(find.text('Nhận feedback'));
    await tester.pumpAndSettle();
    expect(find.text('4. Feedback'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    if (index < learnerResponses.length - 1) {
      await tester.tap(find.text('Lượt tiếp theo'));
      await tester.pumpAndSettle();
      expect(find.text('3. Luyện phản hồi'), findsOneWidget);
    } else {
      await tester.tap(find.text('Hoàn tất'));
    }
  }

  await tester.pumpAndSettle();
  expect(find.text('Phiên luyện tập đã xong'), findsOneWidget);
}

Future<void> _scrollToText(WidgetTester tester, String text) async {
  await tester.dragUntilVisible(
    find.text(text),
    find.byType(ListView),
    const Offset(0, -220),
  );
  await tester.pumpAndSettle();
}
