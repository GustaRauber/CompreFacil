// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:compre_facil/main.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CompreFacilApp());
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo de volta'), findsOneWidget);
    expect(find.text('CompreFácil'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
