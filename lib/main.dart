import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:focustrophy/core/models/session.dart';
import 'package:focustrophy/core/models/subject.dart';
import 'package:focustrophy/core/services/penalty_timer_service.dart';
import 'package:focustrophy/features/settings/bloc/premium_status_bloc.dart';
import 'package:focustrophy/features/timer/bloc/timer_bloc.dart';
import 'package:focustrophy/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(SessionAdapter());
  
  // Open Hive boxes
  await Hive.openBox<Subject>('subjects');
  await Hive.openBox<Session>('sessions');
  
  runApp(const FocusTrophyApp());
}

class FocusTrophyApp extends StatelessWidget {
  const FocusTrophyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TimerBloc(
            penaltyTimerService: PenaltyTimerService(),
          ),
        ),
        BlocProvider(
          create: (context) => PremiumStatusBloc(),
        ),
      ],
      child: const App(),
    );
  }
}