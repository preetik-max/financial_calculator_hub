import 'package:flutter_test/flutter_test.dart';
import 'package:financial_calculator_hub/app/app.dart';

void main() {
  testWidgets(
    'Financial Calculator Hub loads',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const FinancialCalculatorHubApp(),
      );

      expect(
        find.text('Financial Calculators'),
        findsOneWidget,
      );
    },
  );
}