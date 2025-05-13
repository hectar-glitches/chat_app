# Educational Chat App

## Overview

This Flutter-based mobile application provides a modern, intuitive platform for students to engage in both direct messaging and group discussions focused on academic subjects. The app integrates personal chat functionality with subject-specific group threads, enabling students to collaborate, ask questions, and share knowledge in a streamlined interface.

## Features

### Direct Messaging
- One-on-one conversations with fellow students
- Real-time message delivery
- Message reactions (👍, ❤️, 😂, 😮, 😢, 🔥)
- Online status indicators
- Last seen timestamps
- Text-based avatars when images are unavailable

### Group Discussions
- Subject-categorized discussion threads (Biology, Chemistry, Physics, Math)
- Thread-based conversations to maintain context
- User achievements and expertise badges
- Ability to join/leave groups
- Participation metrics

### User Experience
- Dark theme optimized for extended reading sessions
- Salmon/coral accent color scheme for interactive elements
- Customizable privacy settings
- Avatar support (network images and SVG)
- Message reactions and emoji support

## Technical Architecture

### Models
- `User`: Manages user profiles with name, avatar, online status, and achievements
- `ChatMessage`: Encapsulates message content, sender information, timestamps, and reactions
- `QuestionThread`: Represents topic-based discussion threads with participants and metadata

### Providers (State Management)
- `ChatProvider`: Handles direct messaging functionality and state
- `GroupChatProvider`: Manages group discussions and thread interactions
- `UserProvider`: Controls user settings, preferences, and profile information
- `FriendsProvider`: Manages user connections and group memberships

### Key Screens
- `ContactListScreen`: Home screen displaying contacts, joined groups, and trending threads
- `ChatScreen`: Direct messaging interface with reaction capabilities
- `QuestionThreadScreen`: Group discussion interface for subject-specific threads
- `UserSettingsScreen`: Preferences and privacy management

### Utilities
- Dynamic date separators for conversation context
- Message reaction system
- Avatar fallback system for network issues

## Design Decisions

1. **Unified Interface**: Integrates personal and group communications to minimize context switching

2. **Dark Theme**: Designed for extended reading sessions with reduced eye strain

3. **Thread-Based Discussions**: Organizes group conversations by topics for better information retrieval

4. **Achievement System**: Gamifies knowledge sharing through visual indicators of expertise

5. **Privacy Controls**: Granular settings for online visibility, group membership visibility, and AI suggestions

## Development Focus

The app prioritizes:
- Smooth user experience across direct and group messaging
- Reliable fallbacks for network issues (text avatars when images fail)
- Privacy and user control
- Knowledge organization through structured conversations

## Future Enhancements

1. Integration with learning management systems
2. Advanced search functionality
3. Media and document sharing capabilities
4. Enhanced notification system
5. Analytics for learning patterns
