import 'package:flutter/material.dart';
import 'package:focustrophy/core/constants/study_modes.dart';

class StudyModeSelector extends StatelessWidget {
  final StudyMode selectedMode;
  final Function(StudyMode) onModeSelected;

  const StudyModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Study Mode',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: StudyMode.values.length,
            itemBuilder: (context, index) {
              final mode = StudyMode.values[index];
              return _buildModeChip(context, mode);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModeChip(BuildContext context, StudyMode mode) {
    final isSelected = mode == selectedMode;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(
          mode.name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).primaryColor,
        side: BorderSide(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        onSelected: (selected) {
          if (selected) {
            onModeSelected(mode);
          }
        },
      ),
    );
  }
}