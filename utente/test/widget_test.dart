import 'package:flutter_test/flutter_test.dart';
import 'package:utente/info.dart';

void main() {
  testWidgets('shows messages', (WidgetTester tester) async {
    // Render the widget.
    await tester.pumpWidget(Info());
    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();
    // // Verify the output.
    expect(find.text('Non riciclabili'), findsOneWidget);
    //expect(find.text('Message 1 of 1'), findsOneWidget);
  });
}
