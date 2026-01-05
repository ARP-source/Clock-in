import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focustrophy/features/clocks/clocks_selection_screen.dart';
import 'package:focustrophy/features/stats/modern_stats_screen.dart';
import 'package:focustrophy/features/settings/settings_screen.dart';
import 'package:focustrophy/shared/widgets/glass_card.dart';
import 'package:focustrophy/shared/widgets/beams_background.dart';
import 'package:focustrophy/shared/utils/page_transitions.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BeamsBackground(
        beamWidth: 2,
        beamHeight: 15,
        beamNumber: 12,
        lightColor: Colors.white,
        speed: 2,
        noiseIntensity: 1.75,
        scale: 0.2,
        rotation: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                Colors.transparent,
                const Color(0xFF0F0F12).withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.02),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        size: 72,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'CLOCK-IN',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 8,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 40,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'PRECISION FOCUS',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            letterSpacing: 4,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  _MenuButton(
                    icon: Icons.timer_outlined,
                    label: 'START SESSION',
                    color: Colors.white,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      context.pushWithFadeSlide(const ClocksSelectionScreen());
                    },
                  ),
                  const SizedBox(height: 20),
                  _MenuButton(
                    icon: Icons.bar_chart_rounded,
                    label: 'ANALYTICS',
                    color: Colors.white.withOpacity(0.7),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.pushWithFadeSlide(const ModernStatsScreen());
                    },
                  ),
                  const SizedBox(height: 20),
                  _MenuButton(
                    icon: Icons.settings_outlined,
                    label: 'PREFERENCES',
                    color: Colors.white.withOpacity(0.7),
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GlassButton(
        onTap: onTap,
        borderRadius: 20,
        color: Colors.white.withOpacity(0.03),
        child: SizedBox(
          width: 280,
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: color,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: color.withOpacity(0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
