import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_up/app.dart';
import 'package:level_up/core/constants/app_constants.dart';

void main() {
  testWidgets('LevelUpApp boots and displays splash brand tagline', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: LevelUpApp(),
      ),
    );

    // Initial frame on splash screen
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.appTagline), findsOneWidget);
  });
}

