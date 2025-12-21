# FocusTrophy

A cross-platform mobile app for study accountability that penalizes off-app behavior and tracks study sessions with data visualization.

## Features

- **Penalty Timer System**: Automatically adds time to your session when you leave the app
- **Study Modes**: 
  - Pomodoro (25 min work / 5 min break)
  - Efficiency (52 min work / 17 min break)
  - Ultradian (90 min work / 20 min break)
  - Flow Mode (continuous tracking)
- **Subject Management**: Color-coded subjects with horizontal scrolling selector
- **Data Visualization**: Beautiful charts showing focus time vs penalty time
- **Trophy System**: Gold/Silver/Failed status based on penalty time
- **Premium Features**: Ad-free experience and Marathon Mode unlock
- **Responsive Design**: Works in both portrait and landscape orientations

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: flutter_bloc
- **Local Database**: Hive (hive_flutter)
- **Charts**: fl_chart
- **Monetization**: google_mobile_ads, purchases_flutter

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── study_modes.dart
│   ├── models/
│   │   ├── subject.dart
│   │   ├── session.dart
│   │   ├── subject.g.dart
│   │   └── session.g.dart
│   ├── services/
│   │   └── penalty_timer_service.dart
│   └── utils/
│       └── time_utils.dart
├── features/
│   ├── timer/
│   │   ├── bloc/
│   │   │   ├── timer_bloc.dart
│   │   │   ├── timer_event.dart
│   │   │   └── timer_state.dart
│   │   ├── widgets/
│   │   │   ├── circular_timer.dart
│   │   │   ├── subject_selector.dart
│   │   │   ├── study_mode_selector.dart
│   │   │   └── timer_controls.dart
│   │   └── timer_screen.dart
│   ├── stats/
│   │   └── stats_screen.dart
│   └── settings/
│       ├── bloc/
│       │   ├── premium_status_bloc.dart
│       │   ├── premium_status_event.dart
│       │   └── premium_status_state.dart
│       └── settings_screen.dart
├── shared/
│   └── widgets/
│       └── trophy_widget.dart
├── app.dart
└── main.dart
```

## Setup Instructions

### Prerequisites

1. Install Flutter SDK (>=3.0.0)
2. Install Android Studio / Xcode for mobile development
3. Set up Flutter environment variables

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd focustrophy
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive TypeAdapters:
```bash
flutter packages pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

### Building for Production

#### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## Key Features Implementation

### 1. Penalty Timer Service

The `PenaltyTimerService` uses `WidgetsBindingObserver` to monitor app lifecycle states:

- Records `pause_timestamp` when app goes to background
- Calculates time away when app returns to foreground
- Adds penalty time to the session duration
- Provides callbacks for UI updates

### 2. Study Modes

Four different study modes are implemented as an enum:

- **Pomodoro**: Classic 25/5 minute intervals
- **Efficiency**: 52/17 minute intervals for optimal productivity
- **Ultradian**: 90/20 minute deep work sessions
- **Flow Mode**: Continuous tracking until manually stopped

### 3. Data Persistence

Hive is used for local data storage with two main models:

- **Subject**: Stores subject information with color coding
- **Session**: Stores session data including focus time, penalties, and trophy status

### 4. Background Color Changes

The app background changes based on timer state:

- **Pastel Red** (#FFE5E5) during work sessions
- **Pastel Green** (#E5FFE5) during break sessions
- Smooth transitions between states

### 5. Trophy System

Sessions are awarded trophies based on penalty time:

- **Gold**: No penalties (perfect focus)
- **Silver**: Some penalties but session completed
- **Failed**: Session was abandoned

### 6. Monetization

Premium features are implemented with placeholders:

- Banner ads on Stats and Settings screens
- Premium unlock removes ads and enables Marathon Mode
- Uses `PremiumStatusBloc` for state management

## Customization

### Adding New Study Modes

1. Add the mode to the `StudyMode` enum in `lib/core/constants/study_modes.dart`
2. Update the UI components to handle the new mode
3. Test the timer logic with the new duration

### Modifying Colors

1. Update the color constants in `lib/core/constants/app_colors.dart`
2. Update the subject color options in `SubjectSelector`
3. Ensure accessibility contrast ratios are maintained

### Adding New Features

1. Follow the feature-first architecture pattern
2. Create appropriate BLoC components for state management
3. Add Hive models if data persistence is needed
4. Update the UI components accordingly

## Testing

Run the test suite:
```bash
flutter test
```

Run integration tests:
```bash
flutter test integration_test/
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue on GitHub
- Contact support through the app
- Check the documentation for common solutions