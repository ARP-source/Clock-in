# Clock-in - Comprehensive Project Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture & Tech Stack](#architecture--tech-stack)
3. [Features & Functionality](#features--functionality)
4. [UI/UX Design System](#uiux-design-system)
5. [Project Structure](#project-structure)
6. [Implementation Details](#implementation-details)
7. [Setup & Development](#setup--development)
8. [Future Enhancements](#future-enhancements)

---

## Project Overview

**Clock-in** is a modern, minimalist productivity application built with Flutter that helps users track their focus time using various timer methodologies. The app features a premium dark theme with glassmorphism design, particle animations, and sophisticated visual feedback systems.

### Core Concept
Clock-in implements multiple study/focus timer modes (Pomodoro, Efficiency, Ultradian, Flow) with subject-based tracking, penalty systems for interruptions, and comprehensive statistics visualization.

### Design Philosophy
- **2025 Modern Minimalist Aesthetic**: Clean, premium interface with dark theme
- **Glassmorphism**: Semi-transparent cards with backdrop blur effects
- **Neumorphism**: Glowing timer ring with soft shadows
- **Micro-interactions**: Haptic feedback and smooth animations throughout
- **Visual Feedback**: Color-coded transitions and status indicators

---

## Architecture & Tech Stack

### Core Technologies
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: flutter_bloc (BLoC pattern)
- **Local Storage**: Hive (NoSQL database)
- **Charts**: fl_chart
- **Audio/Haptics**: audioplayers, vibration packages

### Architecture Pattern: BLoC (Business Logic Component)

```
┌─────────────────┐
│   Presentation  │ ← UI Widgets (Screens, Components)
│      Layer      │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   BLoC Layer    │ ← Business Logic (Events, States)
│                 │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Data Layer    │ ← Models, Repositories (Hive)
│                 │
└─────────────────┘
```

### Key Dependencies
```yaml
dependencies:
  flutter_bloc: ^8.1.3      # State management
  hive: ^2.2.3              # Local database
  hive_flutter: ^1.1.0      # Hive Flutter integration
  fl_chart: ^0.63.0         # Statistics charts
  audioplayers: ^5.2.1      # Sound effects
  vibration: ^1.8.4         # Haptic feedback
  equatable: ^2.0.5         # Value equality
```

---

## Features & Functionality

### 1. Timer Modes

#### Pomodoro (25/5)
- **Work**: 25 minutes
- **Break**: 5 minutes
- **Color**: Red (#EF4444)
- **Icon**: Timer
- **Use Case**: Short, focused bursts of work

#### Efficiency (52/17)
- **Work**: 52 minutes
- **Break**: 17 minutes
- **Color**: Cyan (#06B6D4)
- **Icon**: Trending Up
- **Use Case**: Optimal productivity based on research

#### Ultradian (90/20)
- **Work**: 90 minutes
- **Break**: 20 minutes
- **Color**: Green (#10B981)
- **Icon**: Psychology
- **Use Case**: Deep work aligned with natural rhythms

#### Flow Mode (Continuous)
- **Work**: Unlimited
- **Break**: Manual
- **Color**: Purple (#8B5CF6)
- **Icon**: Infinity
- **Use Case**: Uninterrupted deep focus sessions

### 2. Subject Management
- Create custom subjects with unique colors
- Color-coded visual identification
- Subject-based session tracking
- Delete subjects with confirmation
- Grid layout with glassmorphic cards

### 3. Timer Functionality
- Real-time countdown display with tabular figures
- Pause/Resume capability
- Stop with confirmation dialog
- Automatic work/break transitions
- Penalty system for interruptions
- Subject color-coded timer ring

### 4. Visual & Audio Feedback

#### Transition Effects
**Work → Break (Break Time)**
- 🟢 Green screen flash (3 times)
- 🔊 System beep sound (3 times)
- 📳 Vibration/haptic feedback (200ms each)

**Break → Work (Back to Work)**
- 🔴 Red screen flash (3 times)
- 🔊 System beep sound (3 times)
- 📳 Vibration/haptic feedback (200ms each)

#### Haptic Feedback
- Light impact on button taps
- Medium impact on timer controls
- Heavy impact on important actions

### 5. Statistics & Analytics

#### Bento Grid Layout
Irregular card sizes for visual interest:
- **Large Trophy Card**: Weekly gold sessions
- **Focus Time Card**: Total hours tracked
- **Penalty Card**: Time added from interruptions
- **Sessions Card**: Total completed sessions
- **Weekly Chart**: 7-day bar chart
- **Top Subject Card**: Most studied subject

#### Metrics Tracked
- Total focus time (hours)
- Total penalty time (minutes)
- Session count
- Gold/Silver/Bronze trophy distribution
- Subject-specific time tracking
- Daily/weekly trends

---

## UI/UX Design System

### Color Palette

#### Primary Colors
```dart
Deep Charcoal:    #0F0F12  // Background
Surface:          #1A1A1F  // Cards, elevated surfaces
Indigo:           #6366F1  // Primary accent
Purple:           #8B5CF6  // Secondary accent
Cyan:             #06B6D4  // Tertiary accent
```

#### Status Colors
```dart
Success Green:    #10B981  // Break time, success states
Warning Amber:    #F59E0B  // Pause, warnings
Error Red:        #EF4444  // Stop, penalties, work transitions
```

#### Text Colors
```dart
Primary Text:     #FFFFFF  // Headings, important text
Secondary Text:   #E5E7EB  // Body text
Tertiary Text:    #9CA3AF  // Subtle text, labels
```

### Typography

#### Font System
```dart
Display Large:    72px, Weight 700, -2 letter-spacing
Headline Large:   32px, Weight 700, -1 letter-spacing
Headline Medium:  28px, Weight 600
Title Large:      22px, Weight 600
Body Medium:      16px, Weight 400
Label Large:      14px, Weight 500
```

#### Special Features
- **Tabular Figures**: Timer digits use monospace numbers for smooth counting
- **Letter Spacing**: Adjusted for premium feel (0.5-1.0)
- **Font Features**: `FontFeature.tabularFigures()` for timer display

### Design Components

#### Glassmorphism
```dart
GlassCard Properties:
- Background: Semi-transparent (#1A1A1F @ 50% opacity)
- Blur: BackdropFilter with 10px blur
- Border: 1px white @ 20% opacity
- Border Radius: 24-32px
- Shadow: Soft drop shadow (0, 10, 20, rgba(0,0,0,0.1))
```

#### Glowing Neumorphic Ring
```dart
Timer Ring Features:
- Base Ring: 12px stroke width
- Glow Layers: 3 layers with increasing blur (10-30px)
- Progress Color: Subject-specific
- Pulse Animation: 800ms ease-in-out when penalties occur
- End Cap: Glowing dot at progress endpoint
```

#### Particle Background
```dart
Particle System:
- Count: 100 particles
- Colors: [Indigo, Purple, Cyan]
- Size: 1.5-3.0px with glow
- Speed: 0.3 (gentle drift)
- Opacity: 30-70%
- Movement: Continuous with edge wrapping
```

### Animation System

#### Page Transitions
```dart
FadeSlidePageRoute:
- Duration: 400ms
- Slide: 3% horizontal offset
- Fade: 0.0 → 1.0 opacity
- Easing: Curves.easeInOutCubic
```

#### Transition Flash
```dart
Flash Animation:
- Duration: 300ms per flash
- Opacity: 0.0 → 0.8 → 0.0
- Count: 3 flashes
- Delay: 100ms between flashes
- Colors: Green (break) / Red (work)
```

#### Micro-interactions
- Button press: Scale 0.95 → 1.0
- Card hover: Subtle elevation change
- Timer pulse: Scale 1.0 → 1.15 (penalties)

---

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── app.dart                           # Root app widget with theme
│
├── core/
│   ├── constants/
│   │   └── study_modes.dart          # Timer mode definitions
│   └── models/
│       ├── subject.dart              # Subject data model (Hive)
│       └── session.dart              # Session data model (Hive)
│
├── features/
│   ├── menu/
│   │   └── menu_screen.dart          # Main menu with particle background
│   │
│   ├── clocks/
│   │   └── clocks_selection_screen.dart  # Timer mode selection
│   │
│   ├── subjects/
│   │   └── subject_selection_screen.dart # Subject CRUD interface
│   │
│   ├── timer/
│   │   ├── timer_screen.dart         # Main timer interface
│   │   ├── bloc/
│   │   │   ├── timer_bloc.dart       # Timer business logic
│   │   │   ├── timer_event.dart      # Timer events
│   │   │   └── timer_state.dart      # Timer states
│   │   └── widgets/
│   │       ├── circular_timer.dart   # Timer display with ring
│   │       ├── glowing_timer_ring.dart   # Custom painted ring
│   │       ├── timer_controls.dart   # Start/Pause/Stop buttons
│   │       ├── subject_selector.dart # Subject picker
│   │       ├── study_mode_selector.dart  # Mode picker
│   │       └── transition_flash.dart # Flash animation widget
│   │
│   ├── stats/
│   │   ├── stats_screen.dart         # Legacy stats (unused)
│   │   └── modern_stats_screen.dart  # Bento grid statistics
│   │
│   └── settings/
│       ├── settings_screen.dart      # Settings interface
│       └── bloc/
│           └── premium_status_bloc.dart  # Premium features
│
└── shared/
    ├── widgets/
    │   ├── glass_card.dart           # Glassmorphic components
    │   └── particle_background.dart  # Particle animation
    └── utils/
        └── page_transitions.dart     # Custom route transitions
```

---

## Implementation Details

### 1. Timer BLoC Implementation

#### Events
```dart
TimerStarted        // Begin timer with mode and subject
TimerPaused         // Pause current session
TimerResumed        // Resume paused session
TimerCancelled      // Stop and save session
TimerReset          // Reset to initial state
StudyModeSelected   // Change timer mode
SubjectSelected     // Change active subject
```

#### States
```dart
TimerState {
  TimerStatus status;           // initial, running, paused, breakTime, completed, cancelled
  StudyMode studyMode;          // Current timer mode
  Subject? selectedSubject;     // Active subject
  Duration displayTime;         // Current countdown
  Duration penaltyTime;         // Accumulated penalties
  double progress;              // 0.0 - 1.0 for ring
  bool isBreak;                 // Work or break session
  bool isWorkSession;           // Computed property
  bool isBreakSession;          // Computed property
}
```

#### Timer Logic Flow
```
1. User selects mode → StudyModeSelected event
2. User selects subject → SubjectSelected event
3. User starts timer → TimerStarted event
4. BLoC creates Ticker stream (1 second intervals)
5. Each tick decrements displayTime
6. When displayTime reaches 0:
   - If work session → transition to break (green flash)
   - If break session → transition to work (red flash)
7. User can pause/resume/cancel at any time
8. On cancel → save session to Hive
```

### 2. Glowing Timer Ring (Custom Painter)

```dart
Paint Layers (bottom to top):
1. Background Ring
   - Subtle white @ 5% opacity
   - Full circle outline

2. Outer Glow Layers (3 layers)
   - Subject color @ varying opacity
   - Increasing blur radius (10-30px)
   - Only painted on progress arc

3. Main Progress Ring
   - Solid subject color
   - 12px stroke width
   - Rounded caps

4. End Cap Glow
   - Glowing dot at progress endpoint
   - 8px blur radius
   - Pulsates with penalties
```

### 3. Particle Animation System

```dart
Particle Class:
- Position: (x, y) normalized 0-1
- Velocity: (vx, vy) small random values
- Size: 1.5-3.0px
- Color: Random from palette
- Opacity: 0.3-0.7

Animation Loop:
1. Update positions based on velocity
2. Wrap particles at screen edges
3. Repaint canvas with new positions
4. Apply glow effect (blur mask)
5. Repeat at 60fps
```

### 4. Transition Flash System

```dart
Flash Sequence:
1. Detect status change (work ↔ break)
2. Set _showingFlash = true
3. Wrap scaffold in TransitionFlash widget
4. Flash animation controller:
   - Forward: 0.0 → 0.8 opacity (300ms)
   - Reverse: 0.8 → 0.0 opacity (300ms)
   - Repeat 3 times with 100ms delay
5. Each flash triggers:
   - SystemSound.play(SystemSoundType.click)
   - Vibration.vibrate(duration: 200ms)
6. On complete: _showingFlash = false
```

### 5. Data Persistence (Hive)

#### Subject Model
```dart
@HiveType(typeId: 0)
class Subject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) int colorHex;
  
  // Stored in 'subjects' box
  // Color stored as int for Hive compatibility
}
```

#### Session Model
```dart
@HiveType(typeId: 1)
class Session {
  @HiveField(0) String id;              // Timestamp
  @HiveField(1) String? subjectId;      // Reference to Subject
  @HiveField(2) int focusMinutes;       // Actual focus time
  @HiveField(3) int penaltyMinutes;     // Interruption penalties
  @HiveField(4) String status;          // Gold/Silver/Bronze
  @HiveField(5) String mode;            // Timer mode used
  
  // Stored in 'sessions' box
  // Trophy status based on penalty ratio
}
```

### 6. Statistics Calculations

#### Trophy Status Algorithm
```dart
if (penaltyMinutes == 0) {
  status = 'Gold';    // Perfect session
} else if (penaltyMinutes < focusMinutes * 0.1) {
  status = 'Silver';  // < 10% penalties
} else {
  status = 'Bronze';  // >= 10% penalties
}
```

#### Weekly Chart Data
```dart
For each of last 7 days:
1. Filter sessions by date
2. Sum focusMinutes for that day
3. Create bar chart data point
4. Display with gradient (indigo → purple)
```

---

## Setup & Development

### Prerequisites
```bash
Flutter SDK: >=3.0.0 <4.0.0
Dart SDK: >=3.0.0
Windows/macOS/Linux development environment
```

### Installation

1. **Clone Repository**
```bash
git clone <repository-url>
cd Clock-inp
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Generate Hive Adapters**
```bash
flutter packages pub run build_runner build
```

4. **Run Application**
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux

# Web
flutter run -d chrome
```

### Build for Production

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release

# Web
flutter build web --release
```

### Development Workflow

1. **Hot Reload**: Press `r` in terminal for instant UI updates
2. **Hot Restart**: Press `R` for full app restart
3. **DevTools**: Access at provided URL for debugging
4. **Logging**: Use `print()` or `debugPrint()` for console logs

---

## Future Enhancements

### Planned Features
- [ ] Cloud sync across devices
- [ ] Custom timer durations
- [ ] Sound customization
- [ ] Dark/Light theme toggle
- [ ] Export statistics to CSV
- [ ] Achievements system
- [ ] Focus streaks tracking
- [ ] Pomodoro long break (4th cycle)
- [ ] Notification system
- [ ] Widget support (desktop)

### Technical Improvements
- [ ] Unit tests for BLoC logic
- [ ] Widget tests for UI components
- [ ] Integration tests for flows
- [ ] Performance profiling
- [ ] Accessibility improvements
- [ ] Internationalization (i18n)
- [ ] Error boundary handling
- [ ] Offline-first architecture

### UI/UX Enhancements
- [ ] Customizable color themes
- [ ] Animation preferences
- [ ] Sound volume control
- [ ] Haptic intensity settings
- [ ] Particle density control
- [ ] Alternative timer visualizations
- [ ] Onboarding tutorial
- [ ] Tips and productivity insights

---

## Credits & Attribution

### Design Inspiration
- **Linear**: Modern minimalist UI patterns
- **Session**: Premium productivity aesthetics
- **shadcn/ui**: Component design philosophy
- **Particles.js**: Particle animation concept

### Technologies
- **Flutter**: Google's UI toolkit
- **Hive**: Efficient local storage
- **fl_chart**: Beautiful chart library
- **BLoC**: Predictable state management

### Development
- **Created**: December 2025
- **Framework**: Flutter 3.0+
- **Platform**: Cross-platform (Windows, macOS, Linux, Web)
- **License**: [Your License]

---

## Contact & Support

For questions, issues, or feature requests:
- **Email**: support@clock-in.app
- **GitHub**: [Repository URL]
- **Documentation**: This file

---

**Last Updated**: December 22, 2025
**Version**: 1.0.0
**Status**: Production Ready ✅
