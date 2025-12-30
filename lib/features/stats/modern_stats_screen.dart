import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:focustrophy/core/models/session.dart';
import 'package:focustrophy/core/models/subject.dart';
import 'package:focustrophy/shared/widgets/glass_card.dart';
import 'package:focustrophy/shared/widgets/shimmer_trophy.dart';
import 'package:focustrophy/shared/widgets/banner_ad_widget.dart';
import 'package:focustrophy/core/services/ad_helper.dart';

class ModernStatsScreen extends StatelessWidget {
  const ModernStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F0F12),
              const Color(0xFF1A1A1F).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: ValueListenableBuilder<Box<Session>>(
            valueListenable: Hive.box<Session>('sessions').listenable(),
            builder: (context, box, _) {
              final sessions = box.values.toList();
              
              if (sessions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 80,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No sessions yet',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start your first focus session!',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: _buildBentoGrid(context, sessions),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBentoGrid(BuildContext context, List<Session> sessions) {
    final totalFocusTime = sessions.fold<int>(0, (sum, s) => sum + s.focusMinutes);
    final totalPenaltyTime = sessions.fold<int>(0, (sum, s) => sum + s.penaltyMinutes);
    final goldSessions = sessions.where((s) => s.status == 'Gold').length;
    final totalSessions = sessions.length;

    return Column(
      children: [
        // Row 1: Large trophy card + Focus time
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large Trophy Card
            Expanded(
              flex: 2,
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                borderRadius: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Trophy',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFFD700).withOpacity(0.3),
                              const Color(0xFFFFA500).withOpacity(0.3),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const ShimmerTrophy(
                          icon: Icons.emoji_events,
                          size: 60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        '$goldSessions Gold',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'out of $totalSessions sessions',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Focus Time Card
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Color(0xFF6366F1),
                      size: 32,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${(totalFocusTime / 60).toStringAsFixed(1)}h',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Focus Time',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2: Penalty Time + Sessions Count
        Row(
          children: [
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFEF4444),
                      size: 32,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${totalPenaltyTime}m',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 36,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Penalties',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF10B981),
                      size: 32,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$totalSessions',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 36,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sessions',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Row 3: Weekly Chart (full width)
        GlassCard(
          padding: const EdgeInsets.all(24),
          borderRadius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: _buildWeeklyChart(sessions),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Row 4: Focus Score Chart
        GlassCard(
          padding: const EdgeInsets.all(24),
          borderRadius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Focus Score Trend',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Performance over last 7 sessions',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: _buildFocusScoreChart(sessions),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Row 5: Top Subject
        GlassCard(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: _buildTopSubject(context, sessions),
        ),
        const SizedBox(height: 16),
        // Ad Banner
        BannerAdWidget(
          adUnitId: AdHelper.statsScreenBannerAdUnitId,
        ),
      ],
    );
  }

  Widget _buildFocusScoreChart(List<Session> sessions) {
    // Get last 7 sessions
    final recentSessions = sessions.length > 7 
        ? sessions.sublist(sessions.length - 7)
        : sessions;
    
    final scoreData = recentSessions.map((s) => s.focusScore).toList();
    
    if (scoreData.isEmpty) {
      return const Center(
        child: Text(
          'No data yet',
          style: TextStyle(color: Color(0xFF9CA3AF)),
        ),
      );
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              scoreData.length,
              (index) => FlSpot(index.toDouble(), scoreData[index]),
            ),
            isCurved: true,
            color: const Color(0xFF10B981),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFF10B981),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF10B981).withOpacity(0.3),
                  const Color(0xFF10B981).withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < scoreData.length) {
                  return Text(
                    '${value.toInt() + 1}',
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildWeeklyChart(List<Session> sessions) {
    final now = DateTime.now();
    final weekData = List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      final daySessions = sessions.where((s) {
        final sessionDate = DateTime.fromMillisecondsSinceEpoch(int.parse(s.id));
        return sessionDate.year == day.year &&
               sessionDate.month == day.month &&
               sessionDate.day == day.day;
      });
      
      final focusMinutes = daySessions.fold<int>(0, (sum, s) => sum + s.focusMinutes);
      return focusMinutes.toDouble();
    });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: weekData.reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                return Text(
                  days[value.toInt()],
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: weekData[index],
                color: const Color(0xFF6366F1),
                width: 24,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopSubject(BuildContext context, List<Session> sessions) {
    final subjectBox = Hive.box<Subject>('subjects');
    final subjectMinutes = <String, int>{};
    
    for (final session in sessions) {
      subjectMinutes[session.subjectId!] = 
          (subjectMinutes[session.subjectId!] ?? 0) + session.focusMinutes;
        }
    
    if (subjectMinutes.isEmpty) {
      return Column(
        children: [
          Text(
            'Top Subject',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'No subject data yet',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }
    
    final topSubjectId = subjectMinutes.entries.reduce((a, b) => 
        a.value > b.value ? a : b).key;
    final topSubject = subjectBox.get(topSubjectId);
    final topMinutes = subjectMinutes[topSubjectId]!;
    
    if (topSubject == null) {
      return const SizedBox.shrink();
    }
    
    final color = Color(topSubject.colorHex);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Subject',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.book_outlined,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topSubject.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(topMinutes / 60).toStringAsFixed(1)} hours studied',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
