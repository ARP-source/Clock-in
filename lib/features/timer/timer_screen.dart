import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focustrophy/features/timer/bloc/timer_bloc.dart';
import 'package:focustrophy/features/timer/bloc/timer_event.dart';
import 'package:focustrophy/features/timer/bloc/timer_state.dart';
import 'package:focustrophy/features/timer/widgets/circular_timer.dart';
import 'package:focustrophy/features/timer/widgets/timer_controls.dart';
import 'package:focustrophy/features/timer/widgets/subject_selector.dart';
import 'package:focustrophy/features/timer/widgets/study_mode_selector.dart';
import 'package:focustrophy/core/models/subject.dart';
import 'package:focustrophy/core/constants/study_modes.dart';
import 'package:focustrophy/features/timer/widgets/transition_flash.dart';
import 'package:focustrophy/shared/widgets/banner_ad_widget.dart';
import 'package:focustrophy/core/services/ad_helper.dart';

class TimerScreen extends StatefulWidget {
  final StudyMode? initialMode;
  final Subject? initialSubject;
  
  const TimerScreen({super.key, this.initialMode, this.initialSubject});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool _showOptions = false;
  bool _showingFlash = false;
  TimerStatus? _previousStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialMode != null) {
        context.read<TimerBloc>().add(StudyModeSelected(widget.initialMode!));
      }
      if (widget.initialSubject != null) {
        context.read<TimerBloc>().add(SubjectSelected(widget.initialSubject));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        // Detect transition from work to break (green flash)
        if (_previousStatus == TimerStatus.running && 
            state.status == TimerStatus.breakTime && 
            !_showingFlash) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _showingFlash = true);
          });
        }
        
        // Detect transition from break to work (red flash)
        if (_previousStatus == TimerStatus.breakTime && 
            state.status == TimerStatus.running && 
            !_showingFlash) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _showingFlash = true);
          });
        }
        
        _previousStatus = state.status;
        
        final isTimerActive = state.status == TimerStatus.running || 
                              state.status == TimerStatus.paused ||
                              state.status == TimerStatus.breakTime;

        final scaffoldContent = Scaffold(
          appBar: isTimerActive ? null : AppBar(
            title: const Text('Clock-in'),
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildPortraitLayout(context, state, isTimerActive),
                ),
              ),
            ),
          ),
        );

        // Show flash animation if transitioning
        if (_showingFlash) {
          final isBreakTime = state.status == TimerStatus.breakTime;
          return TransitionFlash(
            flashColor: isBreakTime 
                ? const Color(0xFF10B981) // Green for break
                : const Color(0xFFEF4444), // Red for work
            onComplete: () {
              setState(() => _showingFlash = false);
            },
            child: scaffoldContent,
          );
        }

        return scaffoldContent;
      },
    );
  }

  Widget _buildPortraitLayout(BuildContext context, TimerState state, bool isTimerActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Menu button (hamburger icon) - always visible
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(
              _showOptions ? Icons.close : Icons.menu,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _showOptions = !_showOptions;
              });
            },
          ),
        ),
        // Show options only when menu is open
        if (_showOptions) ...[
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
          const SizedBox(height: 40),
        ],
        Center(
          child: CircularTimer(
            state: state,
          ),
        ),
        const SizedBox(height: 40),
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
    return BannerAdWidget(
      adUnitId: AdHelper.timerScreenBannerAdUnitId,
    );
  }

  Widget _buildPenaltyIndicator(Duration penaltyTime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEF4444).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFEF4444),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '+${penaltyTime.inMinutes}:${(penaltyTime.inSeconds % 60).toString().padLeft(2, '0')} Penalty',
            style: const TextStyle(
              color: Color(0xFFEF4444),
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ],
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
        title: const Text('About Clock-in'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clock-in v1.0.0',
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
                'Clock-in stores all your data locally on your device. We do not collect, transmit, or share any personal information.',
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
            Text('• Email: support@clock-in.app'),
            SizedBox(height: 8),
            Text('• Visit our website for tutorials and tips'),
            SizedBox(height: 16),
            Text(
              'Feedback',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We love hearing from our users! Send us your suggestions and feature requests for Clock-in.',
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