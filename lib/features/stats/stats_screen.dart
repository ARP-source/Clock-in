import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:focustrophy/core/models/session.dart';
import 'package:focustrophy/core/models/subject.dart';
import 'package:focustrophy/features/settings/bloc/premium_status_bloc.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumStatusBloc, PremiumStatusState>(
      builder: (context, premiumState) {
        final showAds = premiumState is PremiumStatusLoaded && !premiumState.isPremium;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Statistics'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                if (showAds)
                  Container(
                    height: 50,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text(
                        'Ad Placeholder',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsOverview(),
                        const SizedBox(height: 24),
                        _buildWeeklyChart(),
                        const SizedBox(height: 24),
                        _buildSubjectStats(),
                        const SizedBox(height: 24),
                        _buildRecentSessions(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsOverview() {
    return ValueListenableBuilder<Box<Session>>(
      valueListenable: Hive.box<Session>('sessions').listenable(),
      builder: (context, box, _) {
        final sessions = box.values.toList();
        
        if (sessions.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text('No sessions yet. Start your first focus session!'),
              ),
            ),
          );
        }

        final totalFocusTime = sessions.fold<int>(
          0,
          (sum, session) => sum + session.focusMinutes,
        );
        
        final totalPenaltyTime = sessions.fold<int>(
          0,
          (sum, session) => sum + session.penaltyMinutes,
        );
        
        final goldSessions = sessions.where(
          (s) => s.status == 'Gold',
        ).length;
        
        final totalSessions = sessions.length;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Total Focus',
                      '${(totalFocusTime / 60).toStringAsFixed(1)}h',
                      Colors.blue,
                    ),
                    _buildStatItem(
                      'Penalties',
                      '${(totalPenaltyTime / 60).toStringAsFixed(1)}h',
                      Colors.red,
                    ),
                    _buildStatItem(
                      'Gold Rate',
                      '${((goldSessions / totalSessions) * 100).toStringAsFixed(0)}%',
                      Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ValueListenableBuilder<Box<Session>>(
                valueListenable: Hive.box<Session>('sessions').listenable(),
                builder: (context, box, _) {
                  final sessions = box.values.toList();
                  final weeklyData = _getWeeklyData(sessions);
                  
                  if (weeklyData.isEmpty) {
                    return const Center(
                      child: Text('No data for this week'),
                    );
                  }

                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(weeklyData),
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              return Text(days[value.toInt()]);
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toInt()}h');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: _createBarGroups(weeklyData),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getWeeklyData(List<Session> sessions) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekSessions = sessions.where((session) {
      return session.startTime.isAfter(weekStart) && 
             session.startTime.isBefore(weekStart.add(const Duration(days: 7)));
    }).toList();

    final dailyData = List.generate(7, (index) {
      final day = weekStart.add(Duration(days: index));
      final daySessions = weekSessions.where((session) {
        return session.startTime.day == day.day;
      }).toList();

      final focusMinutes = daySessions.fold<int>(
        0,
        (sum, session) => sum + session.focusMinutes,
      );
      
      final penaltyMinutes = daySessions.fold<int>(
        0,
        (sum, session) => sum + session.penaltyMinutes,
      );

      return {
        'day': index,
        'focus': focusMinutes / 60, // Convert to hours
        'penalty': penaltyMinutes / 60,
      };
    });

    return dailyData;
  }

  double _getMaxY(List<Map<String, dynamic>> data) {
    double max = 0;
    for (var day in data) {
      max = (max > day['focus'] + day['penalty']) ? max : day['focus'] + day['penalty'];
    }
    return max + 1; // Add some padding
  }

  List<BarChartGroupData> _createBarGroups(List<Map<String, dynamic>> data) {
    return data.map((day) {
      return BarChartGroupData(
        x: day['day'],
        barRods: [
          BarChartRodData(
            toY: day['focus'],
            color: Colors.blue,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: day['penalty'],
            color: Colors.red,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildSubjectStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subject Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<Box<Session>>(
              valueListenable: Hive.box<Session>('sessions').listenable(),
              builder: (context, sessionBox, _) {
                final sessions = sessionBox.values.toList();
                final subjectBox = Hive.box<Subject>('subjects');
                
                if (sessions.isEmpty) {
                  return const Center(
                    child: Text('No subject data available'),
                  );
                }

                final subjectStats = _getSubjectStats(sessions, subjectBox);
                
                return Column(
                  children: subjectStats.map((stat) => _buildSubjectStatItem(stat)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSubjectStats(
    List<Session> sessions,
    Box<Subject> subjectBox,
  ) {
    final Map<String, Map<String, dynamic>> stats = {};
    
    for (var session in sessions) {
      final subjectId = session.subjectId;
      if (!stats.containsKey(subjectId)) {
        final subject = subjectBox.get(subjectId);
        stats[subjectId] = {
          'name': subject?.name ?? 'Unknown Subject',
          'color': subject != null ? Color(subject.colorHex) : Colors.grey,
          'totalFocus': 0,
          'totalSessions': 0,
          'goldSessions': 0,
        };
      }
      
      stats[subjectId]!['totalFocus'] += session.focusMinutes;
      stats[subjectId]!['totalSessions'] += 1;
      if (session.status == 'Gold') {
        stats[subjectId]!['goldSessions'] += 1;
      }
    }
    
    return stats.values.toList();
  }

  Widget _buildSubjectStatItem(Map<String, dynamic> stat) {
    final focusHours = (stat['totalFocus'] as int) / 60;
    final goldRate = ((stat['goldSessions'] as int) / (stat['totalSessions'] as int)) * 100;
    
    return ListTile(
      leading: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: stat['color'] as Color,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(stat['name'] as String),
      subtitle: Text(
        '${focusHours.toStringAsFixed(1)}h • ${goldRate.toStringAsFixed(0)}% Gold',
      ),
      trailing: Text(
        '${stat['totalSessions']} sessions',
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildRecentSessions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Sessions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<Box<Session>>(
              valueListenable: Hive.box<Session>('sessions').listenable(),
              builder: (context, box, _) {
                final sessions = box.values.toList()
                  ..sort((a, b) => b.startTime.compareTo(a.startTime))
                  ..take(5);
                
                if (sessions.isEmpty) {
                  return const Center(
                    child: Text('No recent sessions'),
                  );
                }

                return Column(
                  children: sessions.map((session) => _buildSessionItem(session)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(Session session) {
    final subjectBox = Hive.box<Subject>('subjects');
    final subject = subjectBox.get(session.subjectId);
    
    return ListTile(
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: _getStatusColor(session.status),
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        subject?.name ?? 'No Subject',
        style: TextStyle(
          color: subject != null ? Color(subject.colorHex) : Colors.grey,
        ),
      ),
      subtitle: Text(
        '${session.focusMinutes}min + ${session.penaltyMinutes}min penalty',
      ),
      trailing: Text(
        session.status,
        style: TextStyle(
          color: _getStatusColor(session.status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Gold':
        return Colors.amber;
      case 'Silver':
        return Colors.grey;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}