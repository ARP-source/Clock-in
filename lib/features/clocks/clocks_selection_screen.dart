import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focustrophy/core/constants/study_modes.dart';
import 'package:focustrophy/features/subjects/subject_selection_screen.dart';
import 'package:focustrophy/shared/widgets/glass_card.dart';
import 'package:focustrophy/shared/utils/page_transitions.dart';

class ClocksSelectionScreen extends StatelessWidget {
  const ClocksSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Clock'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your focus mode',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a timer that matches your study style',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    children: [
                      _ClockCard(
                        studyMode: StudyMode.pomodoro,
                        icon: Icons.timer,
                        color: const Color(0xFFEF4444),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.pushWithFadeSlide(
                            const SubjectSelectionScreen(studyMode: StudyMode.pomodoro),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _ClockCard(
                        studyMode: StudyMode.efficiency,
                        icon: Icons.trending_up,
                        color: const Color(0xFF06B6D4),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.pushWithFadeSlide(
                            const SubjectSelectionScreen(studyMode: StudyMode.efficiency),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _ClockCard(
                        studyMode: StudyMode.ultradian,
                        icon: Icons.psychology,
                        color: const Color(0xFF10B981),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.pushWithFadeSlide(
                            const SubjectSelectionScreen(studyMode: StudyMode.ultradian),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _ClockCard(
                        studyMode: StudyMode.flow,
                        icon: Icons.all_inclusive,
                        color: const Color(0xFF8B5CF6),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.pushWithFadeSlide(
                            const SubjectSelectionScreen(studyMode: StudyMode.flow),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClockCard extends StatelessWidget {
  final StudyMode studyMode;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ClockCard({
    required this.studyMode,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      onTap: onTap,
      borderRadius: 24,
      glowColor: color,
      padding: const EdgeInsets.all(20),
      child: Row(
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
              icon,
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
                  studyMode.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  studyMode.isFlowMode
                      ? studyMode.description
                      : '${studyMode.workMinutes} min work / ${studyMode.breakMinutes} min break',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: color.withOpacity(0.6),
            size: 18,
          ),
        ],
      ),
    );
  }
}
