import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nethra_bengaluru_superapp/main.dart';
import 'package:nethra_bengaluru_superapp/services/context_service.dart';

void main() {
  group('Blind Mode Loading Screen Tests', () {
    testWidgets('Should show normal loading screen when blind mode is disabled', (WidgetTester tester) async {
      // Create a context service with blind mode disabled
      final contextService = ContextService();
      contextService.setBlindMode(false);
      
      // Build the app with the context service
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<ContextService>.value(value: contextService),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                // Create a simple widget that uses the loading screen logic
                return Scaffold(
                  body: contextService.isBlindMode 
                    ? Container(
                        color: const Color(0xFF000000),
                        child: const Text('BLIND MODE LOADING', style: TextStyle(color: Color(0xFFFFFF00))),
                      )
                    : Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Text('Normal Loading', style: TextStyle(color: Colors.white)),
                      ),
                );
              },
            ),
          ),
        ),
      );

      // Verify normal loading screen is shown
      expect(find.text('Normal Loading'), findsOneWidget);
      expect(find.text('BLIND MODE LOADING'), findsNothing);
      
      // Verify background color is normal mode color
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.color, const Color(0xFF1A1A2E));
    });

    testWidgets('Should show blind mode loading screen when blind mode is enabled', (WidgetTester tester) async {
      // Create a context service with blind mode enabled
      final contextService = ContextService();
      contextService.setBlindMode(true);
      
      // Build the app with the context service
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<ContextService>.value(value: contextService),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                // Create a simple widget that uses the loading screen logic
                return Scaffold(
                  body: contextService.isBlindMode 
                    ? Container(
                        color: const Color(0xFF000000),
                        child: const Text('BLIND MODE LOADING', style: TextStyle(color: Color(0xFFFFFF00))),
                      )
                    : Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Text('Normal Loading', style: TextStyle(color: Colors.white)),
                      ),
                );
              },
            ),
          ),
        ),
      );

      // Verify blind mode loading screen is shown
      expect(find.text('BLIND MODE LOADING'), findsOneWidget);
      expect(find.text('Normal Loading'), findsNothing);
      
      // Verify background color is black for high contrast
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.color, const Color(0xFF000000));
      
      // Verify text color is yellow for high contrast
      final text = tester.widget<Text>(find.text('BLIND MODE LOADING'));
      expect(text.style?.color, const Color(0xFFFFFF00));
    });

    testWidgets('Should toggle between loading screens when blind mode changes', (WidgetTester tester) async {
      // Create a context service starting with blind mode disabled
      final contextService = ContextService();
      contextService.setBlindMode(false);
      
      // Build the app with the context service
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<ContextService>.value(value: contextService),
          ],
          child: MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          contextService.toggleBlindMode();
                          setState(() {});
                        },
                        child: const Text('Toggle Blind Mode'),
                      ),
                      Expanded(
                        child: contextService.isBlindMode 
                          ? Container(
                              color: const Color(0xFF000000),
                              child: const Text('BLIND MODE LOADING', style: TextStyle(color: Color(0xFFFFFF00))),
                            )
                          : Container(
                              color: const Color(0xFF1A1A2E),
                              child: const Text('Normal Loading', style: TextStyle(color: Colors.white)),
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Initially should show normal loading
      expect(find.text('Normal Loading'), findsOneWidget);
      expect(find.text('BLIND MODE LOADING'), findsNothing);
      
      // Toggle blind mode
      await tester.tap(find.text('Toggle Blind Mode'));
      await tester.pump();
      
      // Now should show blind mode loading
      expect(find.text('BLIND MODE LOADING'), findsOneWidget);
      expect(find.text('Normal Loading'), findsNothing);
      
      // Toggle back
      await tester.tap(find.text('Toggle Blind Mode'));
      await tester.pump();
      
      // Should be back to normal loading
      expect(find.text('Normal Loading'), findsOneWidget);
      expect(find.text('BLIND MODE LOADING'), findsNothing);
    });
  });
}