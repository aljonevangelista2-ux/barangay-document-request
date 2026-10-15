import 'package:flutter_test/flutter_test.dart';

import 'package:barangay_document_request/main.dart';

void main() {
  testWidgets('shows the home page', (WidgetTester tester) async {
    await tester.pumpWidget(const BarangayApp());
    await tester.pumpAndSettle();

    expect(find.text('Barangay Services'), findsOneWidget);
    expect(find.text('Welcome, Resident!'), findsOneWidget);
  });

  testWidgets('submitting a request adds it to My Requests',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BarangayApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('New Request'));
    await tester.pumpAndSettle();

    // Empty form should fail validation.
    await tester.ensureVisible(find.text('Submit Request'));
    await tester.tap(find.text('Submit Request'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your full name.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Juan Dela Cruz');
    await tester.enterText(find.byType(TextFormField).at(1), 'Purok 1, Clarin');
    await tester.enterText(find.byType(TextFormField).at(2), 'Employment');

    await tester.ensureVisible(find.text('Submit Request'));
    await tester.tap(find.text('Submit Request'));
    await tester.pumpAndSettle();

    // App jumps to My Requests and lists the new request.
    expect(find.text('Barangay Clearance'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
  });
}
