import 'package:coach_e/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hardcoded auth opens coaching shell', (tester) async {
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
  });
}
