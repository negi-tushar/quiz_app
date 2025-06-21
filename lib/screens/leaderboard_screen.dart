// Updated LeaderboardScreen with fixed overflow and enhanced UI

import 'package:flutter/material.dart';
import 'package:quiz_app/common/methods.dart';
import 'package:quiz_app/common/string.dart';
import 'package:quiz_app/service/leaderboard_service.dart';
import 'package:quiz_app/service/shared_pref_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  final LeaderboardService _leaderboardService = LeaderboardService();
  late Future<List<Map<String, dynamic>>> _topScoresFuture;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _topScoresFuture = _leaderboardService.getTopScores();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshScores() async {
    _controller.reset();
    setState(() {
      _topScoresFuture = _leaderboardService.getTopScores();
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.onSurface),
            onPressed: _refreshScores,
          ),
        ],
      ),
      body: Container(
        color: theme.brightness == Brightness.light ? Colors.white : Colors.black38,
        child: Column(
          children: [
            // Header with back button and title

            // Main content with proper constraints
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _topScoresFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: colorScheme.primary, strokeWidth: 3));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: colorScheme.error, size: 48),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Failed to load leaderboard',
                              style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(onPressed: _refreshScores, child: const Text('Retry')),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.leaderboard_outlined,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No scores yet',
                            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Sample data (replace with snapshot.data!)
                    // final data = [
                    //   {
                    //     "lastQuizCompletedAt": "",
                    //     "totalOptimizedScore": 105,
                    //     "userName": "Alex",
                    //     "userImage": "https://randomuser.me/api/portraits/men/32.jpg",
                    //     "userId": "2",
                    //   },
                    //   {
                    //     "lastQuizCompletedAt": "",
                    //     "totalOptimizedScore": 95,
                    //     "userName": "Maria",
                    //     "userImage": "https://randomuser.me/api/portraits/women/44.jpg",
                    //     "userId": "3",
                    //   },
                    //   {
                    //     "lastQuizCompletedAt": "",
                    //     "totalOptimizedScore": 90,
                    //     "userName": "John",
                    //     "userImage": "https://randomuser.me/api/portraits/men/22.jpg",
                    //     "userId": "4",
                    //   },
                    //   {
                    //     "lastQuizCompletedAt": "",
                    //     "totalOptimizedScore": 85,
                    //     "userName": "Sarah",
                    //     "userImage": "https://randomuser.me/api/portraits/women/33.jpg",
                    //     "userId": "5",
                    //   },
                    //   {
                    //     "lastQuizCompletedAt": "",
                    //     "totalOptimizedScore": 80,
                    //     "userName": "Michael",
                    //     "userImage": "https://randomuser.me/api/portraits/men/45.jpg",
                    //     "userId": "6",
                    //   },
                    //   {
                    //     "lastQuizCompletedAt": "",
                    //     "totalOptimizedScore": 1,
                    //     "userName": "Tushar",
                    //     "userImage":
                    //         "https://lh3.googleusercontent.com/a/ACg8ocJf61OrxkEPw0lZ3piLJsbv1kx6xZYKHu_mos8v5xjyk_a6IA=s96-c",
                    //     "userId": "TmE2PhNaOYf61ZdMA6recF7SPT23",
                    //   },
                    // ];
                    final data = snapshot.data!;
                    var topThree = [];
                    if (data.length > 3) {
                      topThree = data.take(3).toList();
                    } else {
                      topThree = data.take(data.length).toList();
                    }
                    final rest = data.skip(3).toList();

                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: CustomScrollView(
                          slivers: [
                            // Top 3 podium section
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: size.height * 0.35, // Responsive height
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    // Podium base

                                    // Podium steps
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        // 2nd place
                                        if (topThree.length >= 2)
                                          _buildPodiumStep(
                                            context,
                                            topThree[1],
                                            rank: 2,
                                            height: size.height * 0.08,
                                            color: colorScheme.secondaryContainer,
                                          ),

                                        // 1st place
                                        if (topThree.isNotEmpty)
                                          _buildPodiumStep(
                                            context,
                                            topThree[0],
                                            rank: 1,
                                            height: size.height * 0.10,
                                            color: colorScheme.primaryContainer,
                                          ),

                                        // 3rd place
                                        if (topThree.length >= 3)
                                          _buildPodiumStep(
                                            context,
                                            topThree[2],
                                            rank: 3,
                                            height: size.height * 0.06,
                                            color: colorScheme.tertiaryContainer,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Rest of the leaderboard
                            SliverList(
                              delegate: SliverChildBuilderDelegate((context, index) {
                                final rank = index + 4;
                                final user = rest[index];
                                final isCurrentUser = user['userId'] == (SharedPrefService.getData(userID) ?? "");
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser
                                        ? colorScheme.primary.withValues(alpha: 0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isCurrentUser
                                          ? colorScheme.primary.withValues(alpha: 0.3)
                                          : colorScheme.surfaceContainerHighest,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: Row(
                                      spacing: 20,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          rank.toString(),
                                          style: textTheme.bodyLarge?.copyWith(
                                            color: isCurrentUser ? colorScheme.primary : colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: (user['userImage'] as String).isEmpty
                                              ? const AssetImage('assets/img/user.png')
                                              : NetworkImage(user['userImage'] as String),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      getFirstName(user['userName'] as String),
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: isCurrentUser ? colorScheme.primary : colorScheme.onSurface,
                                        fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isCurrentUser
                                            ? colorScheme.primary.withValues(alpha: 0.2)
                                            : colorScheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${user['totalOptimizedScore'] ?? 0} pts',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: isCurrentUser ? colorScheme.primary : colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    minLeadingWidth: 0,
                                    horizontalTitleGap: 8,
                                    dense: true,
                                  ),
                                );
                              }, childCount: rest.length),
                            ),

                            // Add some bottom padding
                            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumStep(
    BuildContext context,
    Map<String, dynamic> user, {
    required int rank,
    required double height,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final medalColors = [Colors.amber, Colors.grey.shade400, Colors.brown.shade400];

    return Flexible(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // User info above podium
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.surface,
                  child: CircleAvatar(
                    radius: 40,

                    backgroundImage: (user['userImage'] as String).isEmpty
                        ? const AssetImage('assets/img/user.png')
                        : NetworkImage(user['userImage'] as String),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  getFirstName(user['userName'] as String),
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onBackground, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Icon(Icons.emoji_events, color: medalColors[rank - 1], size: 24),
                const SizedBox(height: 4),
                Text(
                  '${user['totalOptimizedScore'] ?? 0}',
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // Podium step
            Container(
              height: height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(rank == 1 ? 12 : 8),
                  topRight: Radius.circular(rank == 3 ? 12 : 8),
                ),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
