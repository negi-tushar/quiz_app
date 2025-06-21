import 'package:flutter/material.dart';
import 'package:quiz_app/common/quizes_data.dart';
import 'package:quiz_app/model/quiz_model.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

class AllQuizzesScreen extends StatelessWidget {
  const AllQuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        color: theme.brightness == Brightness.light ? Colors.white : Colors.black38,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                'Browse All Quizzes',
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              centerTitle: true,
              backgroundColor: theme.appBarTheme.backgroundColor?.withValues(alpha: 0.9),
              elevation: 4,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, color: colorScheme.onSurface),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,

                      colors: theme.brightness == Brightness.light
                          ? [colorScheme.primary.withValues(alpha: 0.8), colorScheme.primary]
                          : [colorScheme.surfaceContainerHigh, colorScheme.surfaceContainerHighest],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 3 : 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final quiz = allQuizzes[index];
                  return _buildQuizCard(context, quiz, theme, colorScheme, textTheme);
                }, childCount: allQuizzes.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(
    BuildContext context,
    QuizEntry quiz,
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: quiz.color?.withValues(alpha: 0.1) ?? colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: quiz.color?.withValues(alpha: 0.3) ?? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  numberOfQuestions: quiz.numberOfQuestions,
                  questionTimerSeconds: quiz.questionTimerSeconds,
                  category: quiz.category,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: colorScheme.primary.withValues(alpha: 0.15),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Icon(quiz.icon, size: 50, color: quiz.color ?? colorScheme.primary),
                ),
                const SizedBox(height: 12),
                Text(
                  quiz.title,
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  quiz.description,
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${quiz.numberOfQuestions} Qs',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${quiz.questionTimerSeconds}s/Q',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
