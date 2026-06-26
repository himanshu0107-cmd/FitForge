// This is a basic Flutter widget test for FitForge.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitforge/main.dart';
import 'package:fitforge/core/providers/app_providers.dart';

void main() {
  testWidgets('FitForge app starts without crashing', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const FitForgeApp(),
      ),
    );

    // App should render without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
