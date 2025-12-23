import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focustrophy/features/clocks/clocks_selection_screen.dart';
import 'package:focustrophy/features/stats/modern_stats_screen.dart';
import 'package:focustrophy/features/settings/settings_screen.dart';
import 'package:focustrophy/shared/widgets/glass_card.dart';
import 'package:focustrophy/shared/widgets/particle_background.dart';
import 'package:focustrophy/shared/utils/page_transitions.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleBackground(
        particleCount: 100,
        particleColors: const [
          Color(0xFF6366F1),
          Color(0xFF8B5CF6),
          Color(0xFF06B6D4),
        ],
        speed: 0.3,
        particleSize: 1.5,
        child: Container(
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6366F1).withOpacity(0.3),
                        const Color(0xFF8B5CF6).withOpacity(0.3),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Clock-in',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Track your time, stay focused',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 80),
                _MenuButton(
                  icon: Icons.timer_outlined,
                  label: 'Clocks',
                  color: const Color(0xFF6366F1),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pushWithFadeSlide(const ClocksSelectionScreen());
                  },
                ),
                const SizedBox(height: 16),
                _MenuButton(
                  icon: Icons.bar_chart_rounded,
                  label: 'Stats',
                  color: const Color(0xFF8B5CF6),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pushWithFadeSlide(const ModernStatsScreen());
                  },
                ),
                const SizedBox(height: 16),
                _MenuButton(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  color: const Color(0xFF06B6D4),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pushWithFadeSlide(const SettingsScreen());
                  },
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      onTap: onTap,
      borderRadius: 24,
      glowColor: color,
      child: SizedBox(
        width: 300,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
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
                size: 28,
                color: color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color.withOpacity(0.6),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
