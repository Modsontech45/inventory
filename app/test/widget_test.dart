import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:envventory/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ENVentoryApp()));
    await tester.pump();
    expect(find.byType(MaterialApp), findsNothing); // MaterialApp.router used
  });
}
