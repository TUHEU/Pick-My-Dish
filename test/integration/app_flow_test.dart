import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pick_my_dish/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End App Flow', () {
    testWidgets('Complete user journey through the app', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4)); // Wait for splash

      // Verify we're on HomeScreen
      expect(find.text('Welcome'), findsOneWidget);
      
      // Navigate to Recipes Screen
      await tester.tap(find.text('See All'));
      await tester.pumpAndSettle();
      
      // Verify Recipes Screen
      expect(find.text('All Recipes'), findsOneWidget);
      
      // Search for a recipe
      await tester.enterText(find.byType(TextField), 'Toast');
      await tester.pumpAndSettle();
      
      // Favorite a recipe
      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pump();
      
      // Go back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Open side menu
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      
      // Navigate to Favorites
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      
      // Verify favorite is shown
      expect(find.text('Toast with Berries'), findsOneWidget);
    });

    testWidgets('Navigation between auth screens', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      
      // Open side menu and go to profile (which might trigger login)
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      
      // Navigate to Profile
      await tester.tap(find.text('View Profile'));
      await tester.pumpAndSettle();
      
      // Test profile editing
      await tester.enterText(find.byType(TextField), 'updated_username');
      await tester.pump();
      
      expect(find.text('updated_username'), findsOneWidget);
    });
  });
}