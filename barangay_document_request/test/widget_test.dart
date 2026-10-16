import 'package:flutter_test/flutter_test.dart';
import 'package:barangay_document_request/main.dart';

void main() {
  testWidgets('shows the home page', (WidgetTester tester) async {
    await tester.pumpWidget(const BarangayApp());
    await tester.pumpAndSettle();

    expect(find.text('Barangay Services'), findsOneWidget);
    expect(find.text('Welcome, Resident!'), findsOneWidget);
  });

  testWidgets('validates and submits a request', (WidgetTester tester) async {
    await tester.pumpWidget(const BarangayApp());
    await tester.pumpAndSettle();

    // Open the request form from the bottom navigation bar.
    await tester.tap(find.text('New Request').first);
    await tester.pumpAndSettle();

    // Empty form should fail validation.
    final submitButton = find.text('Submit Request');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Please enter your full name.'), findsOneWidget);

    // Fill in name, address and purpose (in that order).
    final fields = find.byType(TextFormField);
    expect(fields, findsAtLeastNWidgets(3));

    await tester.enterText(fields.at(0), 'Juan Dela Cruz');
    await tester.enterText(fields.at(1), 'Purok 1, Clarin');
    await tester.enterText(fields.at(2), 'Employment');

    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // App jumps to My Requests and lists the new request.
    expect(find.text('Barangay Clearance'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
  });
}
