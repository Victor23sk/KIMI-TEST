import 'package:flutter_test/flutter_test.dart';
import 'package:palazzo_ai/core/l10n/app_strings.dart';
import 'package:palazzo_ai/main.dart';

void main() {
  testWidgets('Palazzo splash shows brand', (tester) async {
    await tester.pumpWidget(const PalazzoApp());
    expect(find.text(S.appName), findsWidgets);
    // Advance past splash navigation timer.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.textContaining('Агент'), findsWidgets);
  });
}
