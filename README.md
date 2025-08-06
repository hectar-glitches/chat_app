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

## Architecture

### Folder Structure
- `lib/models`: Data models for users, messages, and threads
- `lib/providers`: State management using the Provider pattern
- `lib/screens`: UI screens for the application
- `lib/widgets`: Reusable UI components
- `lib/utils`: Utilities for error handling, logging, and constants

### Design Patterns
- **Provider Pattern**: For state management
- **Repository Pattern**: For data access (planned for API integration)
- **Factory Pattern**: For creating model instances from various data sources

## Getting Started

### Prerequisites
- Flutter SDK (version 2.10.0 or higher)
- Dart SDK (version 2.16.0 or higher)

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/yourusername/academic-chat-app.git
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the application:
   ```
   flutter run
   ```

## Roadmap

### Short-term Plans
- API Integration for real backend communication
- Push Notifications for new messages
- File and media sharing in chats
- Enhanced user profiles

### Long-term Vision
- Voice and video calls
- Study material sharing
- AI-powered study assistants
- Integration with learning management systems

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
