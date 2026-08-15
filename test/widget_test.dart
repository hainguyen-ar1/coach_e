import 'package:coach_e/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hardcoded auth opens coaching shell', (tester) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CoachEApp());
    expect(find.text('Coach E'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('Vào nhanh bản demo'), findsOneWidget);

    await tester.tap(find.text('Vào nhanh bản demo'));
    await tester.pumpAndSettle();
    expect(find.text('Coaching session'), findsOneWidget);

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

    await tester.ensureVisible(find.byType(EditableText));
    await tester.enterText(
      find.byType(EditableText),
      'First, I explain the context because it helps me sound calm and clear.',
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Nhận feedback'));
    await tester.tap(find.text('Nhận feedback'));
    await tester.pumpAndSettle();
    expect(find.text('4. Feedback'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hoàn tất'));
    await tester.pumpAndSettle();
    expect(find.text('Phiên luyện tập đã xong'), findsOneWidget);
  });
}
