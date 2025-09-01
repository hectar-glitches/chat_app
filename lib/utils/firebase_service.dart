import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart' as app_user;
import '../models/chat_message.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Authentication methods
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'avatarUrl': '',
        'isOnline': true,
        'lastSeen': DateTime.now(),
      });
      return userCredential;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> signOut() async => await _auth.signOut();
  User? getCurrentUser() => _auth.currentUser;

  // User data methods
  Future<app_user.User?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return app_user.User(
          id: doc.id,
          name: data['name'] ?? '',
          avatarUrl: data['avatarUrl'] ?? '',
          isOnline: data['isOnline'] ?? false,
          lastSeen: data['lastSeen'] != null ? (data['lastSeen'] as Timestamp).toDate() : null,
        );
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Chat methods
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());
      
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message.text,
        'lastMessageTime': message.timestamp,
        'lastMessageSenderId': message.senderId,
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage.fromMap(data);
      }).toList();
    });
  }

  // Group chat methods
  Future<String> createGroupChat(String name, String creatorId, List<String> memberIds) async {
    try {
      final groupChatRef = _firestore.collection('group_chats').doc();
      await groupChatRef.set({
        'name': name,
        'creatorId': creatorId,
        'memberIds': [creatorId, ...memberIds],
        'createdAt': DateTime.now(),
        'lastMessage': '',
        'lastMessageTime': DateTime.now(),
      });
      return groupChatRef.id;
    } catch (e) {
      print('Error creating group chat: $e');
      rethrow;
    }
  }
}
