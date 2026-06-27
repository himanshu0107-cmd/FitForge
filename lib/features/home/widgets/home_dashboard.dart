import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/workout_provider.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/providers/program_provider.dart';

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(workoutStreakProvider);
    final historyAsync = ref.watch(workoutHistoryProvider);
    final latestWeightAsync = ref.watch(latestWeightProvider);
    final enrollmentAsync = ref.watch(activeEnrollmentProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back! 💪',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, MMMM d').format(DateTime.now()),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          streakAsync.when(
            data: (streak) => _StreakCard(streak: streak),
            loading: () => const _LoadingCard(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          
          const SizedBox(height: 16),
          
          enrollmentAsync.when(
            data: (enrollment) => enrollment != null
                ? _ActiveProgramCard(enrollment: enrollment)
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          
          enrollmentAsync.maybeWhen(
            data: (enrollment) => SizedBox(height: enrollment != null ? 16 : 0),
            orElse: () => const SizedBox.shrink(),
          ),
          
          Row(
            children: [
              Expanded(
                child: latestWeightAsync.when(
                  data: (weight) => _StatCard(
                    title: 'Current Weight',
                    value: weight != null ? '${weight.weightKg.toStringAsFixed(1)} kg' : 'N/A',
                    icon: Icons.monitor_weight_outlined,
                    color: Colors.blue,
                  ),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: historyAsync.when(
                  data: (history) => _StatCard(
                    title: 'Workouts',
                    value: '${history.where((w) => w.isCompleted).length}',
                    icon: Icons.fitness_center,
                    color: Colors.orange,
                  ),
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          _QuickActionButton(
            label: 'Start Workout',
            icon: Icons.play_circle_filled,
            color: Colors.green,
            onTap: () => context.push('/workout-library'),
          ),
          const SizedBox(height: 8),
          _QuickActionButton(
            label: 'Log Food',
            icon: Icons.restaurant,
            color: Colors.purple,
            onTap: () => context.push('/diet'),
          ),
          const SizedBox(height: 8),
          _QuickActionButton(
            label: 'View Programs',
            icon: Icons.calendar_today,
            color: Colors.blue,
            onTap: () => context.push('/programs'),
          ),
          
          const SizedBox(height: 24),
          
          Text('Recent Activity', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          historyAsync.when(
            data: (history) => history.isEmpty
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No workouts yet. Start your first workout!'),
                  ))
                : Column(
                    children: history.take(5).map((session) => _WorkoutHistoryItem(session: session)).toList(),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Error loading history')),
          ),
        ],
      ),
    );
  }
}

class _ActiveProgramCard extends StatelessWidget {
  final dynamic enrollment;

  const _ActiveProgramCard({required this.enrollment});

  @override
  Widget build(BuildContext context) {
    final startDate = enrollment.startDate as DateTime;
    final daysSinceStart = DateTime.now().difference(startDate).inDays;
    final progress = (enrollment.currentWeek as int) / 12.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bookmark, size: 24, color: Colors.green),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Active Program', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        enrollment.programName as String,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Week ${enrollment.currentWeek}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Day ${enrollment.currentDay}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                Text(
                  '$daysSinceStart days active',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final Map<String, int> streak;

  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_fire_department, size: 32, color: Colors.orange),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Workout Streak', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text(
                    '${streak['current']} days',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text('Best', style: Theme.of(context).textTheme.bodySmall),
                Text('${streak['longest']}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutHistoryItem extends StatelessWidget {
  final dynamic session;

  const _WorkoutHistoryItem({required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.check)),
        title: Text(session.workoutName),
        subtitle: Text(DateFormat('MMM d, h:mm a').format(session.startTime)),
        trailing: Text('${session.durationMinutes} min', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
