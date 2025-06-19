import 'package:flutter/material.dart';
import 'package:quiz_app/common/string.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/service/shared_pref_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  String _userName = 'Guest';

  final List<Map<String, String>> _categories = [
    {'name': 'General Knowledge', 'icon': 'lightbulb_outline'},
    {'name': 'Science & Nature', 'icon': 'science'},
    {'name': 'History', 'icon': 'history'},
    {'name': 'Sports', 'icon': 'sports_soccer'},
    {'name': 'Art & Literature', 'icon': 'palette'},
    {'name': 'Geography', 'icon': 'map'},
    {'name': 'Film & TV', 'icon': 'movie'},
    {'name': 'Music', 'icon': 'music_note'},
    {'name': 'Indian History', 'icon': 'account_balance'},
    {'name': 'Indian Culture', 'icon': 'diversity_3'},
    {'name': 'Uttarakhand', 'icon': 'landscape'},
  ];

  final List<Color> _categoryColors = [
    Colors.blue.shade300,
    Colors.green.shade300,
    Colors.purple.shade300,
    Colors.orange.shade300,
    Colors.teal.shade300,
    Colors.red.shade300,
    Colors.cyan.shade300,
    Colors.indigo.shade300,
    Colors.pink.shade300,
    Colors.lime.shade300,
    Colors.brown.shade300,
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();

    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  Future<void> _loadUserName() async {
    final storedName = await SharedPrefService.getData(userNameKey);
    if (mounted) {
      setState(() {
        _userName = storedName ?? 'Guest';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'lightbulb_outline':
        return Icons.lightbulb_outline_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'history':
        return Icons.history_rounded;
      case 'sports_soccer':
        return Icons.sports_soccer_rounded;
      case 'palette':
        return Icons.palette_rounded;
      case 'map':
        return Icons.map_rounded;
      case 'movie':
        return Icons.movie_rounded;
      case 'music_note':
        return Icons.music_note_rounded;
      case 'account_balance':
        return Icons.account_balance_rounded;
      case 'diversity_3':
        return Icons.diversity_3_rounded;
      case 'landscape':
        return Icons.landscape_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.brightness == Brightness.light
                ? [colorScheme.surfaceContainerHighest, colorScheme.surface]
                : [colorScheme.surfaceContainerHigh, colorScheme.surface],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top - 60),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          'Hello, $_userName',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Text(
                    'Explore Categories',
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dive into quizzes across various exciting topics.',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return _buildCategoryCard(
                          context,
                          category['name']!,
                          category['icon']!,
                          _categoryColors[index % _categoryColors.length],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  Text(
                    'Quick Quizzes',
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Challenge yourself with timed quizzes based on question count!',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  _buildQuickQuizButton(
                    context,
                    'Fast Quiz',
                    '10 Questions | 10s per Q',
                    10,
                    10,
                    Icons.flash_on_rounded,
                    colorScheme.primary,
                  ),
                  const SizedBox(height: 15),
                  _buildQuickQuizButton(
                    context,
                    'Medium Quiz',
                    '15 Questions | 15s per Q',
                    15,
                    15,
                    Icons.timer_rounded,
                    colorScheme.secondary,
                  ),
                  const SizedBox(height: 15),
                  _buildQuickQuizButton(
                    context,
                    'Long Quiz',
                    '20 Questions | 20s per Q',
                    20,
                    20,
                    Icons.hourglass_empty_rounded,
                    colorScheme.tertiary,
                  ),
                  const SizedBox(height: 30),

                  Text(
                    'Daily Challenge',
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Test your skills with today\'s special quiz!',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  _buildFeaturedQuizCard(context),
                  const SizedBox(height: 30),

                  Text(
                    'More Options',
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Discover additional features and challenges.',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  _buildOptionCard(context, 'Browse All Quizzes', Icons.list_alt_rounded, () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Browse All Quizzes! (Coming soon)')));
                  }),
                  const SizedBox(height: 15),
                  _buildOptionCard(context, 'Leaderboard', Icons.leaderboard_rounded, () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Leaderboard! (Coming soon)')));
                  }),
                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickQuizButton(
    BuildContext context,
    String title,
    String subtitle,
    int numberOfQuestions,
    int questionTimerSeconds,
    IconData icon,
    Color startColor,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: startColor.withOpacity(0.25), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 5)),
        ],
        gradient: LinearGradient(
          colors: [startColor, startColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    QuizScreen(numberOfQuestions: numberOfQuestions, questionTimerSeconds: questionTimerSeconds),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 38, color: Colors.white),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(fontSize: 15, color: Colors.white.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 25, color: Colors.white.withOpacity(0.8)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String categoryName, String iconName, Color cardColor) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              numberOfQuestions: 10, // You can make this configurable or default
              questionTimerSeconds: 15, // You can make this configurable or default
              category: categoryName, // <--- THIS IS THE KEY: Pass the category name
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cardColor, cardColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: cardColor.withOpacity(0.3), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getIconData(iconName), size: 45, color: Colors.white),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: textTheme.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        color: colorScheme.surface,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          splashColor: colorScheme.primary.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 30, color: colorScheme.primary),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 20, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedQuizCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primaryContainer.withRed(120)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Starting Daily Challenge!')));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const QuizScreen(numberOfQuestions: 10, questionTimerSeconds: 12),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 35, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      'Daily Challenge',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  'Complete today\'s unique quiz and climb the ranks!',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.9), fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
