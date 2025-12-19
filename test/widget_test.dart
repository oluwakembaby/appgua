import 'package:flutter_test/flutter_test.dart';
import 'package:aqua_harmony/main.dart';
import 'package:aqua_harmony/ui/screens/game_screen.dart';

void main() {
  testWidgets('App builds and shows GameScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AquaHarmonyApp());

    // Verify that GameScreen is present
    expect(find.byType(GameScreen), findsOneWidget);
  });
}
