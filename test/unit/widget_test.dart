import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pick_my_dish/main.dart';
import 'package:pick_my_dish/Screens/splash_screen.dart';
import 'package:pick_my_dish/Screens/home_screen.dart';
import 'package:pick_my_dish/Screens/login_screen.dart';
import 'package:pick_my_dish/Screens/register_screen.dart';
import 'package:pick_my_dish/Screens/recipe_screen.dart';
import 'package:pick_my_dish/Screens/favorite_screen.dart';
import 'package:pick_my_dish/Screens/profile_screen.dart';
import 'package:pick_my_dish/constants.dart';

void main() {
  group('Constants Tests', () {
    test('Text styles are properly defined', () {
      expect(title.fontSize, 37);
      expect(title.color, Colors.white);
      expect(mediumtitle.fontSize, 23);
      expect(text.fontSize, 18);
    });

    test('isPasswordVisible initial state', () {
      expect(isPasswordVisible, false);
    });
  });

  group('Main App Test', () {
    testWidgets('App starts with SplashScreen', (WidgetTester tester) async {
      await tester.pumpWidget(const PickMyDish());
      
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('SplashScreen Tests', () {
    testWidgets('SplashScreen displays logo and navigates after delay', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
      
      // Verify logo is displayed
      expect(find.byType(Image), findsOneWidget);
      
      // Fast-forward time and rebuild
      await tester.pump(const Duration(seconds: 3));
      
      // Should navigate to HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

  group('HomeScreen Tests', () {
    testWidgets('HomeScreen displays welcome message and sections', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      // Verify main elements are present
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('What would you like to cook today?'), findsOneWidget);
      expect(find.text('Personalize Your Recipes'), findsOneWidget);
      expect(find.text('Today\'s Fresh Recipe'), findsOneWidget);
      
      // Verify recipe cards are displayed
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('HomeScreen drawer opens and shows menu items', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      // Tap hamburger menu
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      
      // Verify drawer content
      expect(find.text('kynmmarshall'), findsOneWidget);
      expect(find.text('View Profile'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('Personalization section interacts correctly', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      // Test emotion dropdown
      await tester.tap(find.text('How are you feeling?'));
      await tester.pumpAndSettle();
      
      expect(find.text('Happy'), findsOneWidget);
      expect(find.text('Sad'), findsOneWidget);
      expect(find.text('Energetic'), findsOneWidget);
      
      // Test time dropdown
      await tester.tap(find.text('Cooking Time'));
      await tester.pumpAndSettle();
      
      expect(find.text('15 mins'), findsOneWidget);
      expect(find.text('30 mins'), findsOneWidget);
    });
  });

  group('LoginScreen Tests', () {
    testWidgets('LoginScreen displays all form elements', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      
      expect(find.text('PICK MY DISH'), findsOneWidget);
      expect(find.text('Cook in easy way'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Not Registered Yet?'), findsOneWidget);
      expect(find.text('Register Now'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      
      // Initially password should be obscured
      final passwordField = find.byType(TextField).at(1);
      expect(tester.widget<TextField>(passwordField).obscureText, true);
      
      // Tap visibility icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      
      // Password should now be visible
      expect(tester.widget<TextField>(passwordField).obscureText, false);
    });

    testWidgets('Navigation to RegisterScreen works', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      
      await tester.tap(find.text('Register Now'));
      await tester.pumpAndSettle();
      
      expect(find.byType(RegisterScreen), findsOneWidget);
    });
  });

  group('RegisterScreen Tests', () {
    testWidgets('RegisterScreen displays all form fields', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
      
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Already Registered?'), findsOneWidget);
      expect(find.text('Login Now'), findsOneWidget);
    });
  });

  group('RecipeScreen Tests', () {
    testWidgets('RecipeScreen displays all recipes and search', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RecipesScreen()));
      
      expect(find.text('All Recipes'), findsOneWidget);
      expect(find.text('Search recipes...'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('Recipe search functionality works', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RecipesScreen()));
      
      // Initial state should show all recipes
      expect(find.text('Toast with Berries'), findsOneWidget);
      expect(find.text('Chicken Burger'), findsOneWidget);
      
      // Enter search query
      await tester.enterText(find.byType(TextField), 'Toast');
      await tester.pump();
      
      // Should only show matching recipes
      expect(find.text('Toast with Berries'), findsOneWidget);
      expect(find.text('Chicken Burger'), findsNothing);
    });

    testWidgets('Favorite toggle works on recipe cards', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RecipesScreen()));
      
      // Find favorite icons
      final favoriteIcons = find.byIcon(Icons.favorite_border);
      expect(favoriteIcons, findsWidgets);
      
      // Tap first favorite icon
      await tester.tap(favoriteIcons.first);
      await tester.pump();
      
      // Should change to filled heart
      expect(find.byIcon(Icons.favorite), findsWidgets);
    });
  });

  group('FavoriteScreen Tests', () {
    testWidgets('FavoriteScreen shows empty state when no favorites', 
        (WidgetTester tester) async {
      // Clear favorites for this test
      RecipesScreenState.allRecipes.forEach((recipe) {
        recipe['isFavorite'] = false;
      });
      
      await tester.pumpWidget(const MaterialApp(home: FavoritesScreen()));
      
      expect(find.text('No favorite recipes yet'), findsOneWidget);
    });

    testWidgets('FavoriteScreen displays favorite recipes', 
        (WidgetTester tester) async {
      // Set some recipes as favorites
      RecipesScreenState.allRecipes[0]['isFavorite'] = true;
      RecipesScreenState.allRecipes[1]['isFavorite'] = true;
      
      await tester.pumpWidget(const MaterialApp(home: FavoritesScreen()));
      
      expect(find.text('Favorite Recipes'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('ProfileScreen Tests', () {
    testWidgets('ProfileScreen displays user information', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
      
      expect(find.text('kynmmarshall'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('Username can be edited', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
      
      // Find and update username field
      final usernameField = find.byType(TextField);
      await tester.enterText(usernameField, 'new_username');
      
      expect(find.text('new_username'), findsOneWidget);
    });
  });
}