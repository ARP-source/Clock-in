import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focustrophy/features/timer/bloc/timer_bloc.dart';
import 'package:focustrophy/features/timer/bloc/timer_event.dart';
import 'package:focustrophy/features/timer/bloc/timer_state.dart';
import 'package:focustrophy/features/timer/widgets/circular_timer.dart';
import 'package:focustrophy/features/timer/widgets/subject_selector.dart';
import 'package:focustrophy/features/timer/widgets/study_mode_selector.dart';
import 'package:focustrophy/features/timer/widgets/timer_controls.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool _showOptions = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        // Background color changes based on timer state
        Color backgroundColor = Colors.white;
        if (state.isWorkSession) {
          backgroundColor = const Color(0xFFFF6961); // Bright pastel red
        } else if (state.isBreakSession) {
          backgroundColor = const Color(0xFFE5FFE5); // Pastel green
        }

        // Check if timer is active (running or paused)
        final isTimerActive = state.status == TimerStatus.running || 
                              state.status == TimerStatus.paused ||
                              state.status == TimerStatus.breakTime;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: isTimerActive ? null : AppBar(
            title: const Text('FocusTrophy'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildPortraitLayout(context, state, isTimerActive),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortraitLayout(BuildContext context, TimerState state, bool isTimerActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Menu button when timer is active
        if (isTimerActive) ...[
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                _showOptions ? Icons.close : Icons.menu,
                color: const Color(0xFF27213C),
              ),
              onPressed: () {
                setState(() {
                  _showOptions = !_showOptions;
                });
              },
            ),
          ),
        ],
        // Show options only when not in focus mode OR when menu is open
        if (!isTimerActive || _showOptions) ...[
          const SizedBox(height: 20),
          StudyModeSelector(
            selectedMode: state.studyMode,
            onModeSelected: (mode) {
              context.read<TimerBloc>().add(StudyModeSelected(mode));
            },
          ),
          const SizedBox(height: 30),
          SubjectSelector(
            selectedSubject: state.selectedSubject,
            onSubjectSelected: (subject) {
              context.read<TimerBloc>().add(SubjectSelected(subject));
            },
          ),
          const SizedBox(height: 40),
        ] else ...[
          const SizedBox(height: 60),
        ],
        Center(
          child: CircularTimer(
            state: state,
          ),
        ),
        const SizedBox(height: 30),
        TimerControls(
          state: state,
        ),
        if (state.penaltyTime > Duration.zero) ...[
          const SizedBox(height: 20),
          _buildPenaltyIndicator(state.penaltyTime),
        ],
        const SizedBox(height: 30),
        // Ad Banner placeholder
        _buildAdBanner(),
      ],
    );
  }

  Widget _buildAdBanner() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: const Center(
        child: Text(
          'Ad Space',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPenaltyIndicator(Duration penaltyTime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Text(
        '+${penaltyTime.inMinutes}:${(penaltyTime.inSeconds % 60).toString().padLeft(2, '0')} Time Added',
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                _showPrivacyPolicyDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.support),
              title: const Text('Support'),
              onTap: () {
                Navigator.pop(context);
                _showSupportDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About FocusTrophy'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FocusTrophy v1.0.0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'A study accountability app that helps you stay focused by tracking your study sessions and penalizing off-app behavior.',
            ),
            SizedBox(height: 12),
            Text(
              'Stay focused, earn trophies, and achieve your goals!',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Collection',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'FocusTrophy stores all your data locally on your device. We do not collect, transmit, or share any personal information.',
              ),
              SizedBox(height: 16),
              Text(
                'Local Storage',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Your study sessions, subjects, and preferences are stored securely on your device using local storage.',
              ),
              SizedBox(height: 16),
              Text(
                'Contact',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'For privacy concerns, please contact us through the Support section.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('• Check our FAQ section for common questions'),
            SizedBox(height: 8),
            Text('• Email: support@focustrophy.app'),
            SizedBox(height: 8),
            Text('• Visit our website for tutorials and tips'),
            SizedBox(height: 16),
            Text(
              'Feedback',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We love hearing from our users! Send us your suggestions and feature requests.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}