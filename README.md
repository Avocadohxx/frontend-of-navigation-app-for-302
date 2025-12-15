# Campus Navigation App - Flutter Frontend

A comprehensive smart campus navigation application built with Flutter, featuring indoor-outdoor mapping, AR navigation, real-time classroom status monitoring, and user management.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Prerequisites & Requirements](#2-prerequisites--requirements)
3. [Installation Instructions](#3-installation-instructions)
4. [Project Architecture](#4-project-architecture)
5. [Key Features](#5-key-features)

---

## 1. Project Overview

The Campus Navigation App is a modern, cross-platform mobile application designed for Shanghai Ocean University. It provides students and faculty with intelligent navigation, real-time classroom availability, AR-enhanced wayfinding, and comprehensive campus information services.

### Technology Stack

- **Framework**: Flutter 3.38.3
- **Language**: Dart 3.10
- **State Management**: StatefulWidget with setState
- **Backend Integration**: REST API with JWT authentication
- **Map Engine**: flutter_map with OpenStreetMap tiles
- **Real-time Features**: HTTP polling for classroom status
- **Platforms**: Android, iOS, Web

### Key Technologies

| Technology | Purpose |
|-----------|---------|
| `flutter_map` | Interactive map rendering with vector tiles |
| `latlong2` | GPS coordinate handling |
| `geolocator` | Real-time location tracking |
| `http` | Backend API communication |
| `shared_preferences` | Local data persistence |
| `image_picker` | Avatar upload functionality |
| `google_fonts` | Custom typography |

---

## 2. Prerequisites & Requirements

### Required Software

1. **Flutter SDK** (Version 3.38.3 or higher)
   - Download: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter --version`

2. **Dart SDK** (Version 3.10 or higher)
   - Included with Flutter SDK

3. **Android Studio** (for Android development)
   - Download: https://developer.android.com/studio
   - Required components:
     - Android SDK
     - Android SDK Platform-Tools
     - Android SDK Build-Tools
     - Android Emulator

4. **Xcode** (for iOS development - macOS only)
   - Download from Mac App Store
   - Install Command Line Tools: `xcode-select --install`

5. **Visual Studio Code** (Recommended IDE)
   - Download: https://code.visualstudio.com/
   - Required extensions:
     - Flutter
     - Dart

6. **Git**
   - Download: https://git-scm.com/downloads

### System Requirements

**Windows:**
- Windows 10 or later (64-bit)
- 8 GB RAM minimum
- 2.8 GB disk space

**macOS:**
- macOS 10.14 (Mojave) or later
- 8 GB RAM minimum
- 2.8 GB disk space

**Linux:**
- 64-bit distribution
- 8 GB RAM minimum
- 2.8 GB disk space

### Backend Server

The app requires a running backend server. See backend repository at:
```
C:\Users\hxx\code\backend-of-navigation-app-for-302
```

---

## 3. Installation Instructions

### Step 1: Clone the Repository

```bash
# Navigate to your desired directory
cd C:\Users\hxx\Documents\AAstudy

# If not already cloned, clone the repository
git clone <repository-url> Campus_Navigation_Based_On_Flutter
cd Campus_Navigation_Based_On_Flutter
```

### Step 2: Verify Flutter Installation

```bash
# Check Flutter installation
flutter doctor

# Expected output should show:
# ✓ Flutter (Channel stable, 3.38.3, on <your-os>)
# ✓ Android toolchain - develop for Android devices
# ✓ Xcode - develop for iOS and macOS (macOS only)
# ✓ Chrome - develop for the web
# ✓ Android Studio
# ✓ VS Code
# ✓ Connected device
```

If any items show ✗, follow the instructions provided by `flutter doctor` to resolve them.

### Step 3: Install Dependencies

```bash
# Install all dependencies from pubspec.yaml
flutter pub get

# This will install:
# - flutter_map
# - latlong2
# - geolocator
# - http
# - shared_preferences
# - image_picker
# - google_fonts
# - url_launcher
# - cupertino_icons
```

### Step 4: Configure Backend URL

Update the backend URL in the following files to match your backend server:

**lib/pages/edit_profile_page.dart** (line 27):
```dart
final String _baseUrl = 'http://192.168.2.9:3000'; // Change to your backend URL
```

**lib/pages/login_page.dart** (if exists):
```dart
final String _baseUrl = 'http://192.168.2.9:3000'; // Change to your backend URL
```

### Step 5: Add Required Assets

Ensure the following images are present in `assets/images/`:
- `smart-path.png`
- `classroom.jpg`
- `ar.jpg`
- `tech.jpg`
- `cross.jpg`
- `ai.png`
- User avatar images

### Step 6: Run the Application

**Option A: Android Emulator**
```bash
# List available devices
flutter devices

# Run on Android emulator
flutter run -d emulator-5554

# Or simply (Flutter will prompt device selection)
flutter run
```

**Option B: Physical Device**
```bash
# Enable USB debugging on your device
# Connect device via USB
# Trust the computer on your device

# Run on connected device
flutter run
```

**Option C: iOS Simulator (macOS only)**
```bash
# Start iOS simulator
open -a Simulator

# Run on iOS simulator
flutter run -d "iPhone 14"
```

**Option D: Chrome (Web)**
```bash
# Enable web support (if not already enabled)
flutter config --enable-web

# Run in Chrome
flutter run -d chrome
```

### Step 7: Build for Production

**Android APK:**
```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (for Google Play):**
```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

**iOS (macOS only):**
```bash
# Build for iOS
flutter build ios --release
```

**Web:**
```bash
# Build for web
flutter build web --release

# Output: build/web/
```

### Common Commands

```bash
# Clean build cache
flutter clean

# Reinstall dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Analyze code for issues
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Hot reload (while app is running)
# Press 'r' in terminal

# Hot restart (while app is running)
# Press 'R' in terminal

# Quit (while app is running)
# Press 'q' in terminal
```

### Troubleshooting

**Issue: "Waiting for another flutter command to release the startup lock"**
```bash
# Kill other Flutter processes
taskkill /F /IM dart.exe /T  # Windows
pkill -f dart                # macOS/Linux
```

**Issue: Dependencies not resolving**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

**Issue: Android build fails**
```bash
# In android directory
cd android
./gradlew clean  # Linux/macOS
gradlew clean    # Windows
cd ..
flutter build apk
```

---

## 4. Project Architecture

### Directory Structure

```
Campus_Navigation_Based_On_Flutter/
├── android/                 # Android native code
├── ios/                     # iOS native code
├── lib/                     # Main application code
│   ├── app/                # App-wide components
│   │   ├── bottom_nav_controller.dart    # Bottom navigation logic
│   │   └── app_bottomNavigationBar.dart  # Bottom nav UI
│   ├── models/             # Data models
│   │   └── user_model.dart               # User data structure
│   ├── pages/              # Application screens
│   │   ├── home_page.dart                # Home dashboard
│   │   ├── map_page.dart                 # Map & navigation
│   │   ├── classroom_status_page.dart    # Real-time classroom
│   │   ├── contacts_page.dart            # Contact directory
│   │   ├── profile_page.dart             # User profile
│   │   ├── edit_profile_page.dart        # Profile editor
│   │   ├── login_page.dart               # Authentication
│   │   └── register_page.dart            # User registration
│   └── main.dart           # Application entry point
├── assets/                 # Static resources
│   └── images/             # Image assets
├── test/                   # Unit and widget tests
├── pubspec.yaml            # Dependencies configuration
└── README.md               # This file
```

### Architecture Pattern

The app uses a **layered architecture** with clear separation of concerns:

1. **Presentation Layer** (`lib/pages/`)
   - StatefulWidget-based screens
   - UI components and user interactions
   - Local state management with setState()

2. **Business Logic Layer** (`lib/app/`)
   - Navigation controllers
   - Shared widgets
   - App-wide state (theme, language)

3. **Data Layer** (`lib/models/`)
   - Data models (UserModel, Classroom, etc.)
   - API communication (HTTP requests)
   - Local storage (SharedPreferences)

### State Management

- **Local State**: `setState()` for screen-specific state
- **Inherited State**: `InheritedWidget` for navigation callbacks and app settings
- **Persistent State**: `SharedPreferences` for theme, language, and auth tokens

### Navigation Flow

```
Login → Register (optional) → Bottom Nav Controller
                                      ↓
        ┌─────────────────────────────┼─────────────────────────────┐
        ↓                             ↓                             ↓
    Home Page                    Map Page                   Classroom Status
        ↓                             ↓                             ↓
  Contacts Page               Profile Page                  Edit Profile
```

---

## 5. Key Features

### 5.1 Interactive Map Navigation

**File**: `lib/pages/map_page.dart`

**Description**: Full-featured campus map with route planning and AR navigation

**Key Components**:
- **Map Engine**: flutter_map with OpenStreetMap tiles
- **Location Services**: GPS tracking via geolocator
- **Route Planning**:
  - Straight-line path (light blue dashed line)
  - Road path with waypoints (purple solid line)
- **Search**: Location search for buildings and landmarks
- **AR Navigation**: Simulated AR overlay for directions

**Features**:
- Real-time GPS positioning
- Animated path drawing
- Predefined routes for major destinations:
  - Shanghai Ocean University Library
  - First Teaching Building
  - AIEN Institute
  - Third Building
- Dual path visualization (straight vs. road)
- AR navigation mode with 3D arrow guidance

**Usage**:
1. Search for a destination (e.g., "library", "first building")
2. View straight-line path automatically
3. Click "Route Planning" button for road path
4. Click "AR Navigation" for immersive guidance

---

### 5.2 Real-time Classroom Status

**File**: `lib/pages/classroom_status_page.dart`

**Description**: Live monitoring of classroom availability across campus buildings

**Key Components**:
- **Status Monitoring**: Real-time occupancy tracking
- **Filters**: Building and floor selection
- **Timeline Booking**: Visual time slot booking interface
- **Status Categories**:
  - Available (Green)
  - In Class (Red)
  - Reserved (Orange)
  - Study (Blue)
  - Maintenance (Grey)

**Technical Features**:
- ESP32 IR sensor simulation
- MQTT protocol indicators
- Redis Stream metrics display
- Animated status updates
- QPS and latency monitoring

**Classroom Data**:
- 16 classrooms across 3 buildings
- 6 floors coverage
- Real-time status updates (when enabled)
- Course schedule integration

**Usage**:
1. Filter by building and floor
2. View real-time availability statistics
3. Click a classroom for detailed timeline
4. Select time slots for booking
5. Confirm reservation

---

### 5.3 User Profile Management

**Files**:
- `lib/pages/profile_page.dart`
- `lib/pages/edit_profile_page.dart`

**Description**: Complete user account management with avatar upload

**Profile Information**:
- Username (read-only)
- Phone number (editable)
- Email address (editable)
- Student ID
- School/Department
- Grade level
- Last login time
- Avatar image

**Avatar Upload**:
- **Platform Support**: Web and mobile
- **Web**: Uses `Uint8List` and `Image.memory()`
- **Mobile**: Uses `File` and `Image.file()`
- **Storage**: Aliyun OSS with presigned URLs
- **Flow**: Select image → Preview → Save → Upload to OSS

**Features**:
- Real-time avatar preview
- Cross-platform image handling
- JWT authentication
- Field validation
- Error handling on save

**Usage**:
1. View profile information
2. Click "Edit Profile" button
3. Tap avatar to change image
4. Update phone/email fields
5. Click "Save Changes" to persist
6. Logout functionality with confirmation

---

### 5.4 Campus Contacts Directory

**File**: `lib/pages/contacts_page.dart`

**Description**: Comprehensive directory of campus contacts

**Contact Types**:
- Professors
- Associate Professors
- Department Chairs
- Teaching Assistants
- Students
- Class Monitors

**Features**:
- Search and filter contacts
- Detailed contact information:
  - Name
  - Role
  - Department
  - Phone number
  - Email address
- Quick actions:
  - Call
  - Email

**Sample Contacts** (8 preset entries):
- Prof. Zhang (Computer Science)
- Dr. Li (Software Engineering)
- Dean Wang (Department Chair)
- Liu (Student)
- Chen (Student)
- TA Zhao (AI Department)
- Prof. Sun (Data Science)
- Zhou (Class Monitor)

**Usage**:
1. Browse contact list
2. Tap contact for details
3. Use "Call" or "Email" buttons
4. View department information

---

### 5.5 Smart Home Dashboard

**File**: `lib/pages/home_page.dart`

**Description**: Central hub showcasing all app features with technology details

**Smart Features Grid**:

1. **Indoor-Outdoor Map**
   - Vector tiles + 3D path
   - Image: `smart-path.png`

2. **Real-time Classroom**
   - ESP32 + MQTT status
   - Image: `classroom.jpg`

3. **AR Navigation**
   - ARCore + 3D arrows
   - Image: `ar.jpg`

4. **Tech Stack**
   - Flutter + NestJS + PostGIS
   - Image: `tech.jpg`

5. **Cross Platform**
   - iOS + Android support
   - Image: `cross.jpg`

6. **AI Optimized**
   - Smart path planning
   - Image: `ai.png`

**Features**:
- User welcome card with avatar
- Service cards with detailed tech info
- Settings panel:
  - Theme switching (Light/Dark)
  - Language switching (English/Chinese)
- Interactive tech details modal for each feature
- AR navigation demo

**Technology Details**:
Each feature card opens a modal with:
- Core technology stack
- Feature specifications
- Implementation details
- Demo/trial options (for AR)

**Bilingual Support**:
- English and Chinese languages
- Dynamic UI updates
- Persistent language preference
- Bottom navigation bar localization

---

## Additional Information

### Authentication Flow

1. User launches app → Login Page
2. Enter credentials → JWT token received
3. Token stored in SharedPreferences
4. Token included in all API requests via Authorization header
5. Logout clears token and returns to login

### API Integration

All API endpoints use the base URL configured in each page (default: `http://192.168.2.9:3000`)

**Key Endpoints**:
- `/auth/login` - User authentication
- `/auth/register` - New user registration
- `/auth/update-profile` - Update user info
- `/auth/avatar/signature` - Get presigned URL for avatar upload
- `/auth/avatar/update` - Notify backend of new avatar URL

### Theme System

**Light Mode**:
- Background: `#F8F5F0`
- Card background: White
- Primary: Blue
- Text: Black87

**Dark Mode**:
- Background: `#121212`
- Card background: `#1E1E1E`
- Primary: Blue
- Text: White87

### Map Configuration

**Default Location**: Starfish Plaza (海星广场)
- Latitude: 30.882118
- Longitude: 121.893462

**Map Tiles**: OpenStreetMap
- URL: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
- Fallback: `https://a.tile.openstreetmap.org/{z}/{x}/{y}.png`
- Alternative: Amap (Gaode) tiles for China (commented out)

**Zoom Levels**:
- Default: 17.0
- Min: 1.0
- Max: 19.0

---

## Contributing

When contributing to this repository:

1. Follow the existing code style
2. Use meaningful commit messages
3. Test on both Android and iOS before submitting
4. Update this README if adding new features
5. Do not commit sensitive information (API keys, tokens)

---

## Support

For issues or questions:
- Check Flutter documentation: https://flutter.dev/docs
- Review this README thoroughly
- Contact project maintainers

---

## License

This project is for educational purposes at Shanghai Ocean University.

---

**Last Updated**: December 2025
**Flutter Version**: 3.38.3
**Dart Version**: 3.10
