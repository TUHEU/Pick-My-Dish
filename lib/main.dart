import 'package:flutter/material.dart';
import 'package:pick_my_dish/Providers/recipe_provider.dart';
import 'package:pick_my_dish/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pick_my_dish/Screens/splash_screen.dart';
import 'package:pick_my_dish/Screens/login_screen.dart';
import 'package:pick_my_dish/Screens/register_screen.dart';
import 'package:pick_my_dish/Screens/home_screen.dart';
import 'package:pick_my_dish/Screens/ingredient_input_screen.dart';
import 'package:pick_my_dish/Screens/recipe_screen.dart';
import 'package:pick_my_dish/Screens/favorite_screen.dart';
import 'package:pick_my_dish/Screens/profile_screen.dart';
import 'package:pick_my_dish/Screens/recipe_upload_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const PickMyDish(),
    ),
  );
}

class PickMyDish extends StatelessWidget {
  const PickMyDish({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AppLoaderScreen(), // Changed to AppLoaderScreen
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/ingredients': (context) => const IngredientInputScreen(),
        '/recipes': (context) => const RecipesScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/upload': (context) => const RecipeUploadScreen(),
      },
    );
  }
}

/// New screen that checks login state and redirects accordingly
class AppLoaderScreen extends StatefulWidget {
  const AppLoaderScreen({super.key});

  @override
  State<AppLoaderScreen> createState() => _AppLoaderScreenState();
}

class _AppLoaderScreenState extends State<AppLoaderScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize user provider (load saved data)
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.init();

    // Add a small delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 500));

    // Navigate based on login state
    if (mounted) {
      if (userProvider.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/logo.png'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              "Loading...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'TimesNewRoman',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
