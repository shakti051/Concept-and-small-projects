import 'package:flc_rest_api_test/app/app.dart';
// import 'package:flc_rest_api_test/counter/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      // expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
