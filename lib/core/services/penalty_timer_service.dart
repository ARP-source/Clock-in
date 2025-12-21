import 'dart:async';
import 'package:flutter/widgets.dart';

class PenaltyTimerService with WidgetsBindingObserver {
  DateTime? _sessionStartTime;
  DateTime? _pauseTimestamp;
  Duration _totalPenaltyTime = Duration.zero;
  Duration _currentSessionDuration = Duration.zero;
  bool _isSessionActive = false;
  
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isPaused = false;
  Duration? _presetDuration;

  // Callbacks for state changes
  Function(Duration penaltyTime)? onPenaltyAdded;
  Function(Duration sessionDuration)? onSessionUpdate;
  Function()? onSessionCompleted;

  PenaltyTimerService() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
  }

  // Start a new study session
  void startSession({Duration? presetDuration}) {
    _sessionStartTime = DateTime.now();
    _isSessionActive = true;
    _isPaused = false;
    _elapsedSeconds = 0;
    _currentSessionDuration = Duration.zero;
    _presetDuration = presetDuration;
    
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    
    if (_presetDuration != null) {
      // For preset durations like Pomodoro
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isPaused) return;
        _elapsedSeconds++;
        _currentSessionDuration = Duration(seconds: _elapsedSeconds);
        onSessionUpdate?.call(_currentSessionDuration);
        
        if (_elapsedSeconds >= _presetDuration!.inSeconds) {
          completeSession();
        }
      });
    } else {
      // For flow mode (continuous tracking)
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isPaused) return;
        _elapsedSeconds++;
        _currentSessionDuration = Duration(seconds: _elapsedSeconds);
        onSessionUpdate?.call(_currentSessionDuration);
      });
    }
  }

  // Pause the current session
  void pauseSession() {
    if (!_isSessionActive || _isPaused) return;
    _isPaused = true;
  }

  // Resume the current session
  void resumeSession() {
    if (!_isSessionActive || !_isPaused) return;
    _isPaused = false;
  }

  // Complete the current session
  void completeSession() {
    if (!_isSessionActive) return;
    
    _timer?.cancel();
    _isSessionActive = false;
    onSessionCompleted?.call();
  }

  // Cancel the current session
  void cancelSession() {
    _timer?.cancel();
    _isSessionActive = false;
    _sessionStartTime = null;
    _elapsedSeconds = 0;
    _currentSessionDuration = Duration.zero;
  }

  // Get current session info
  Duration get currentSessionDuration => _currentSessionDuration;
  Duration get totalPenaltyTime => _totalPenaltyTime;
  bool get isSessionActive => _isSessionActive;
  bool get isPaused => _isPaused;
  DateTime? get sessionStartTime => _sessionStartTime;

  // Reset penalty time (called when session is successfully completed)
  void resetPenalty() {
    _totalPenaltyTime = Duration.zero;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!_isSessionActive) return;

    switch (state) {
      case AppLifecycleState.paused:
        // App went to background - record pause time
        _pauseTimestamp = DateTime.now();
        break;
        
      case AppLifecycleState.resumed:
        // App returned to foreground - calculate penalty
        if (_pauseTimestamp != null) {
          final timeAway = DateTime.now().difference(_pauseTimestamp!);
          if (timeAway > const Duration(seconds: 1)) {
            // Add penalty time (excluding brief interruptions)
            _totalPenaltyTime += timeAway;
            onPenaltyAdded?.call(timeAway);
          }
          _pauseTimestamp = null;
        }
        break;
        
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        // Handle other states if needed
        break;
    }
  }
}