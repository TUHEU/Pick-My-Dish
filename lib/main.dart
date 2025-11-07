import 'package:flutter/material.dart';

void main() {
  // Run the app starting with PickMyDishApp widget
  runApp(const PickMyDishApp());
}

/// Main app widget that sets up the theme and initial screen
class PickMyDishApp extends StatelessWidget {
  const PickMyDishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PickMyDish',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Primary brand color
          brightness: Brightness.light,
        ),
        useMaterial3: true, // Enable Material 3 design
        fontFamily: 'Inter', // Custom font family
      ),
      home: const SplashScreen(), // Start with splash screen
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

/// Splash Screen with entrance animations
/// Shows app logo and transitions to home screen after delay
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  
  // Animation controllers for splash screen effects
  late AnimationController _controller;
  late Animation<double> _scaleAnimation; // Scale effect for logo
  late Animation<double> _fadeAnimation;  // Fade in effect for content

  @override
  void initState() {
    super.initState();
    _initializeAnimations(); // Set up animations
    _initializeApp();        // Handle app initialization and navigation
  }

  /// Sets up all animations used in the splash screen
  void _initializeAnimations() {
    // Main animation controller with 1.5 second duration
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this, // Use current widget as ticker provider
    );

    // Scale animation: starts at 50% size and grows to 100%
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Bouncy scaling effect
    ));

    // Fade animation: starts invisible and fades in
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn, // Smooth fade in
    ));

    // Start the animations
    _controller.forward();
  }

  /// Handles app initialization and navigation to home screen
  void _initializeApp() async {
    // Wait for 3 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 3));
    
    // Only navigate if widget is still in the tree
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Fade transition between screens
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary, // Use theme color
      body: Center(
        child: AnimatedBuilder(
          animation: _controller, // Rebuild when animation updates
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value, // Apply fade effect
              child: Transform.scale(
                scale: _scaleAnimation.value, // Apply scale effect
                child: child, // The actual content to animate
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated App Icon Container
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white, // White background for logo
                  borderRadius: BorderRadius.circular(28), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Subtle shadow
                      blurRadius: 20,
                      offset: const Offset(0, 8), // Shadow position
                    ),
                  ],
                ),
                child: Icon(
                  Icons.restaurant_menu, // App logo icon
                  size: 70,
                  color: Theme.of(context).colorScheme.primary, // Theme color
                ),
              ),
              const SizedBox(height: 32), // Spacing between elements
              
              // App Title with gradient text effect
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.8), // Gradient from solid to semi-transparent
                  ],
                ).createShader(bounds),
                child: const Text(
                  'PickMyDish',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Base color for gradient
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Subtitle with delayed appearance
              AnimatedOpacity(
                opacity: _controller.value > 0.5 ? 1.0 : 0.0, // Show after 50% animation
                duration: const Duration(milliseconds: 500),
                child: const Text(
                  'Your Personal Recipe Companion',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70, // Semi-transparent white
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              
              // Loading indicator to show app is initializing
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8), // Semi-transparent white
                ),
                strokeWidth: 3, // Thinner progress indicator
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Main Home Screen with bottom navigation
/// Handles switching between Home, Explore, and Profile sections
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Current selected tab index

  // List of main pages for navigation
  final List<Widget> _pages = [
    const HomeContent(),   // Home tab content
    const ExploreScreen(), // Explore tab content
    const ProfileScreen(), // Profile tab content
  ];

  /// Navigates to the Settings screen
  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Only show app bar on home screen, not on explore/profile
      appBar: _currentIndex == 0
          ? AppBar(
              title: const Text('Pick-My-Dish'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              elevation: 0, // Remove shadow
              centerTitle: false,
              actions: [
                // Settings button in top right
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => _navigateToSettings(context),
                ),
              ],
            )
          : null,
      body: _pages[_currentIndex], // Display current page
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index; // Update selected tab
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Placeholder navigation methods for home screen actions
  void _navigateToRecipeSearch(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipe Search - Coming Soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _navigateToFavorites(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Favorites - Coming Soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

/// Home Content Screen
/// Main dashboard with welcome message, quick actions, and recent activity
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  // Placeholder navigation methods for action cards
  void _navigateToRecipeSearch(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipe Search - Coming Soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _navigateToFavorites(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Favorites - Coming Soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0), // Consistent spacing around content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header Section with gradient background
          Container(
            width: double.infinity, // Full width container
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.primary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Pick-My-Dish! 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary, // Theme color
                    height: 1.2, // Line height for better readability
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Struggling to decide what to cook? Let us help you discover amazing recipes based on what you have and what you love.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700, // Subtle text color
                    height: 1.5, // Comfortable line spacing
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40), // Section spacing
          
          // Quick Actions Section Header
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600, // Semi-bold for section headers
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          
          // Quick Actions Grid - 2x2 grid of feature cards
          GridView.count(
            shrinkWrap: true, // Allow grid to scroll within list
            physics: const NeverScrollableScrollPhysics(), // Prevent nested scrolling
            crossAxisCount: 2, // 2 cards per row
            crossAxisSpacing: 16, // Horizontal spacing between cards
            mainAxisSpacing: 16, // Vertical spacing between cards
            children: [
              // Find Recipes Card
              _buildActionCard(
                context: context,
                icon: Icons.search_rounded,
                title: 'Find Recipes',
                subtitle: 'Search by ingredients',
                color: Colors.blue,
                onTap: () => _navigateToRecipeSearch(context),
              ),
              
              // Favorites Card
              _buildActionCard(
                context: context,
                icon: Icons.favorite_rounded,
                title: 'My Favorites',
                subtitle: 'Saved recipes',
                color: Colors.red,
                onTap: () => _navigateToFavorites(context),
              ),
              
              // Random Recipe Card
              _buildActionCard(
                context: context,
                icon: Icons.shuffle_rounded,
                title: 'Surprise Me',
                subtitle: 'Random recipe',
                color: Colors.purple,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Random Recipe - Coming Soon!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              
              // Meal Planner Card
              _buildActionCard(
                context: context,
                icon: Icons.calendar_today_rounded,
                title: 'Meal Plan',
                subtitle: 'Weekly planning',
                color: Colors.green,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Meal Planner - Coming Soon!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 40), // Section spacing
          
          // Recent Activity Section (Placeholder)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50, // Very light grey background
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200), // Subtle border
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your cooking journey starts here! Explore recipes and save your favorites to see them in this section.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600, // Medium grey for body text
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build consistent action cards
  /// Each card has an icon, title, subtitle, and tap action
  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color, // Primary color for the card
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2, // Subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded card corners
      ),
      child: InkWell(
        onTap: onTap, // Handle card taps
        borderRadius: BorderRadius.circular(16), // Match card border radius
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular icon container with colored background
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1), // Light version of primary color
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color, // Primary color for icon
                  size: 28,
                ),
              ),
              const SizedBox(height: 12), // Spacing between icon and text
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color, // Use primary color for title
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4), // Small spacing between title and subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600, // Grey for secondary text
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Explore Screen - Placeholder for future explore functionality
/// Will contain recipe discovery, categories, and search features
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_rounded,
              size: 80,
              color: Colors.grey, // Grey icon for placeholder
            ),
            SizedBox(height: 20),
            Text(
              'Explore Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Content coming soon...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Profile Screen - Placeholder for future user profile functionality
/// Will contain user account, preferences, and cooking history
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_rounded,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Profile Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Content coming soon...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings Screen - Placeholder for future app settings
/// Will contain app preferences, notifications, and account settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context), // Back navigation
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_rounded,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Settings Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Content coming soon...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
