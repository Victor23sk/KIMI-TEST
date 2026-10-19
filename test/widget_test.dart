import 'package:flutter_test/flutter_test.dart';
import 'package:palazzo_ai/core/l10n/app_strings.dart';
import 'package:palazzo_ai/main.dart';
import 'package:palazzo_ai/state/app_state.dart';

void main() {
  testWidgets('Palazzo splash shows brand', (tester) async {
    await tester.pumpWidget(PalazzoApp(state: AppState()));
    expect(find.text(S.appName), findsWidgets);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.textContaining('Агент'), findsWidgets);
  });
}
