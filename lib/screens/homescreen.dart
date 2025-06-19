// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz_screen.dart'; // Import QuizScreen

class HomeScreen extends StatefulWidget {
  final String userName; // Accept username as a parameter

  const HomeScreen({super.key, this.userName = 'Guest'}); // Default to 'Guest' if not provided

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  // Dummy data for categories
  final List<Map<String, String>> _categories = [
    {'name': 'General Knowledge', 'icon': 'lightbulb_outline'},
    {'name': 'Science & Nature', 'icon': 'science'},
    {'name': 'History', 'icon': 'history'},
    {'name': 'Sports', 'icon': 'sports_soccer'},
    {'name': 'Art & Literature', 'icon': 'palette'},
    {'name': 'Geography', 'icon': 'map'},
    {'name': 'Film & TV', 'icon': 'movie'},
    {'name': 'Music', 'icon': 'music_note'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Animation duration
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn), // Smooth fade-in
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(
      // Slide from slightly below
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic), // A bit bouncy slide
    );

    _controller.forward(); // Start the animation when the screen loads
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  // Helper to get IconData from a string (for categories)
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'lightbulb_outline':
        return Icons.lightbulb_outline;
      case 'science':
        return Icons.science;
      case 'history':
        return Icons.history;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'palette':
        return Icons.palette;
      case 'map':
        return Icons.map;
      case 'movie':
        return Icons.movie;
      case 'music_note':
        return Icons.music_note;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme data for consistent styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      // Apply a subtle gradient background to the entire screen
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.brightness == Brightness.light
                ? [Colors.yellow.shade100, Colors.white, Colors.yellow.shade50] // Light gradient
                : [Colors.grey.shade900, Colors.black, Colors.grey.shade800], // Dark gradient (light black)
          ),
        ),
        child: CustomScrollView(
          // Use CustomScrollView for flexible layout and scrolling
          slivers: [
            SliverAppBar(
              title: Text(
                'Welcome to Quiz App!',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.appBarTheme.foregroundColor, // Use AppBar's foreground color
                ),
              ),
              centerTitle: true,
              backgroundColor: theme.appBarTheme.backgroundColor?.withOpacity(
                0.9,
              ), // Slightly opaque AppBar for better visibility
              elevation: 4, // Keep some elevation for AppBar
              floating: true, // AppBar can float above content
              snap: true,
              expandedHeight: 70.0, // A bit taller AppBar
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: theme.brightness == Brightness.light
                          ? [Colors.yellow.shade600, Colors.yellow.shade800]
                          : [const Color(0xFF2C2C2C), const Color(0xFF3A3A3A)],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              // Padding for the main content area
              padding: const EdgeInsets.all(20.0),
              sliver: SliverList(
                // Use SliverList for scrollable content
                delegate: SliverChildListDelegate([
                  // Animated welcome text
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Text(
                        'Hello, ${widget.userName}!', // Use widget.userName for StatefulWidget
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800, // Make it extra bold
                          color: colorScheme.primary, // Use theme primary color
                          fontSize: 34, // Slightly larger font size
                          shadows: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(2, 2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Choose Your Quiz!',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground, // Use themed text color for background
                      fontSize: 28, // Adjusted font size
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Quiz Length Buttons
                  _buildQuizCategoryButton(
                    context,
                    'Fast Quiz (10 Questions)',
                    10,
                    10, // 10 seconds per question for fast quiz
                  ),
                  const SizedBox(height: 20),
                  _buildQuizCategoryButton(
                    context,
                    'Medium Quiz (15 Questions)',
                    15,
                    15, // 15 seconds per question
                  ),
                  const SizedBox(height: 20),
                  _buildQuizCategoryButton(
                    context,
                    'Long Quiz (20 Questions)',
                    20,
                    20, // 20 seconds per question
                  ),
                  const SizedBox(height: 40), // Separator for new section
                  // Explore Categories Section
                  Text(
                    'Explore Categories',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 160, // Fixed height for horizontal category list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return _buildCategoryCard(context, category['name']!, category['icon']!);
                      },
                    ),
                  ),
                  const SizedBox(height: 40), // Separator for More Options
                  // More Options Section
                  Text(
                    'More Options',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildOptionCard(context, 'Browse All Quizzes', Icons.list_alt, () {
                    /* TODO: Implement navigation to a screen with all quizzes */
                  }),
                  const SizedBox(height: 15),
                  _buildOptionCard(context, 'Leaderboard', Icons.leaderboard, () {
                    /* TODO: Implement navigation to Leaderboard screen */
                  }),
                  const SizedBox(height: 30), // Bottom padding
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build quiz length buttons
  Widget _buildQuizCategoryButton(BuildContext context, String title, int numberOfQuestions, int questionTimerSeconds) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3), // Shadow color based on primary
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          // Gradient for buttons
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  QuizScreen(numberOfQuestions: numberOfQuestions, questionTimerSeconds: questionTimerSeconds),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make button transparent to show Container's gradient
          foregroundColor: colorScheme.onPrimary, // Text color on primary
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 30), // More padding
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0, // No intrinsic elevation as Container handles shadow
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700, // Bolder text
            color: colorScheme.onPrimary, // Ensure text color is from button style's foreground
          ),
        ),
      ),
    );
  }

  // Helper method to build individual category cards
  Widget _buildCategoryCard(BuildContext context, String categoryName, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () {
        // TODO: Implement navigation to a quiz screen filtered by this category
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tapped on $categoryName category!')));
      },
      child: Container(
        width: 140, // Fixed width for category cards
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: theme.cardColor, // Use themed card color
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 4)),
          ],
          gradient: LinearGradient(
            // Subtle gradient for category cards
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.brightness == Brightness.light
                ? [colorScheme.surface, Colors.grey.shade100]
                : [colorScheme.surface, colorScheme.surface.withOpacity(0.8)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconData(iconName),
              size: 50,
              color: colorScheme.secondary, // Icon color
            ),
            const SizedBox(height: 10),
            Text(
              categoryName,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build "More Options" cards/buttons
  Widget _buildOptionCard(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3)),
        ],
        gradient: LinearGradient(
          // Subtle gradient for option cards
          colors: theme.brightness == Brightness.light
              ? [Colors.blueGrey.shade50, Colors.blueGrey.shade100] // Light subtle gradient
              : [const Color(0xFF3A3A3A), const Color(0xFF4A4A4A)], // Dark subtle gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparent background to show Container's gradient
          foregroundColor: colorScheme.onSurface, // Text/icon color
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0, // No intrinsic elevation
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 30, color: colorScheme.primary), // Icon with primary color
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 20, color: colorScheme.onSurface.withOpacity(0.6)), // Forward arrow
          ],
        ),
      ),
    );
  }
}
