import 'package:flutter_test/flutter_test.dart';
import 'package:pterodactyl_app/main.dart';

void main() {
  testWidgets('app should work', (tester) async {
    await tester.pumpWidget(new MyApp());
    expect(true);
  });
}
