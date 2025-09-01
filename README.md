# Academic Chat App

A chat platform designed to facilitate direct messaging and group discussions around academic subjects. 

## Features

### Messaging and Discussions
- **Direct Messaging**: Private conversations between students
- **Question Threads**: Topic-based group discussions organized by subject
- **Subject-Based Groups**: Join groups like "Anatomists", "Alchemists", etc.

### User Experience
- **Dark Theme**: Modern dark theme with salmon accents for improved readability
- **Real-time Status**: See which contacts are online and when others were last active
- **Message Reactions**: React to messages with emojis
- **Achievements**: Display user expertise and accomplishments

### Technical Features
- **Pagination**: Efficient loading of chat messages
- **Error Handling**: Graceful handling of network issues and image loading failures
- **Responsive Design**: Consistent experience across different devices
- **State Management**: Proper state management using Provider
- **Firebase Backend**: Real-time messaging, authentication, and storage
- **Push Notifications**: Get notified about new messages
- **Offline Support**: Access previous conversations even without internet

## Architecture

### Folder Structure
- `lib/models`: Data models for users, messages, and threads
- `lib/providers`: State management using the Provider pattern
- `lib/screens`: UI screens for the application
- `lib/widgets`: Reusable UI components
- `lib/utils`: Utility services and helper functions

### Design Patterns
- **Provider Pattern**: For state management
- **Repository Pattern**: For data access with Firebase
- **Factory Pattern**: For creating model instances from various data sources

## Getting Started

### Prerequisites
- Flutter SDK (version 3.7.2 or higher)
- Dart SDK (version 3.0.0 or higher)
- Firebase account for backend services

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/yourusername/academic-chat-app.git
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Setup Firebase:
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files (google-services.json and GoogleService-Info.plist)
   - Enable Authentication, Firestore, and Storage in the Firebase Console

4. Run the application:
   ```
   flutter run
   ```

## Production Deployment Guide

### Android Release

1. Update the app information in `android/app/build.gradle.kts`:
   ```kotlin
   defaultConfig {
       applicationId = "com.yourdomain.chatapp"
       versionCode = flutter.versionCode
       versionName = flutter.versionName
   }
   ```

2. Set up signing configuration:
   - Create a keystore file: `keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key`
   - Create a `key.properties` file in the android folder with your keystore information
   - Configure gradle to use your keystore in `android/app/build.gradle.kts`

3. Build the release APK or App Bundle:
   ```bash
   # For APK
   flutter build apk --release
   
   # For App Bundle (Google Play)
   flutter build appbundle --release
   ```

### iOS Release

1. Update the Bundle Identifier in Xcode to your domain
2. Configure app signing and provisioning profiles
3. Build the release version:
   ```bash
   flutter build ios --release
   ```
4. Archive and upload to App Store Connect using Xcode

### Performance Optimizations

- Enable Proguard for Android by configuring `android/app/build.gradle.kts`
- Implement image caching and compression
- Use pagination for loading chat messages
- Enable Firebase Performance Monitoring

### Error Handling and Monitoring

- Implement Firebase Crashlytics for crash reporting
- Add proper error boundaries and fallback UI
- Set up logging for critical operations
- Create a feedback mechanism for users to report issues

## Roadmap

### Short-term Plans
- Enhanced file and media sharing
- Advanced user profiles
- Rich text formatting in messages
- Read receipts

### Long-term Vision
- Voice and video calls
- Study material sharing
- AI-powered study assistants
- Integration with learning management systems

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
