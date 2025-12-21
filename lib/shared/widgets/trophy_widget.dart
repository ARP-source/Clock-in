import 'package:flutter/material.dart';
import 'package:focustrophy/core/constants/app_colors.dart';

class TrophyWidget extends StatelessWidget {
  final String status;
  final VoidCallback? onTap;

  const TrophyWidget({
    super.key,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getBorderColor(),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              size: 48,
              color: _getIconColor(),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getDescription(),
              style: TextStyle(
                fontSize: 12,
                color: _getTextColor().withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case 'Gold':
        return AppColors.gold.withOpacity(0.1);
      case 'Silver':
        return AppColors.silver.withOpacity(0.1);
      case 'Failed':
        return AppColors.error.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case 'Gold':
        return AppColors.gold;
      case 'Silver':
        return AppColors.silver;
      case 'Failed':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  Color _getIconColor() {
    switch (status) {
      case 'Gold':
        return AppColors.gold;
      case 'Silver':
        return AppColors.silver;
      case 'Failed':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case 'Gold':
        return const Color(0xFFB8860B); // Dark gold
      case 'Silver':
        return const Color(0xFF708090); // Slate gray
      case 'Failed':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case 'Gold':
        return Icons.emoji_events;
      case 'Silver':
        return Icons.emoji_events;
      case 'Failed':
        return Icons.close;
      default:
        return Icons.help_outline;
    }
  }

  String _getDescription() {
    switch (status) {
      case 'Gold':
        return 'Perfect focus session!';
      case 'Silver':
        return 'Good job with some distractions';
      case 'Failed':
        return 'Session was interrupted';
      default:
        return 'Unknown status';
    }
  }
}