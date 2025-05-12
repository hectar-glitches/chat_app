import 'package:flutter/material.dart';

class GroupChatsScreen extends StatelessWidget {
  const GroupChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Chats')),
      body: Column(
        children: [
          // Global Group Chats Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Global Group Chats',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        10, // Replace with actual global group chat count
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Global Group Chat ${index + 1}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'User123: Typing...', // Example typing indicator
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Text('👍', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 4),
                                Text('❤️', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 4),
                                Text('😂', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          // Handle navigation to the selected global group chat
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Local Group Chats Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Local Group Chats',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Local Group Chat ${index + 1}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'User456: Typing...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Text('👍', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 4),
                                Text('🔥', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 4),
                                Text('🎉', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          // Handle navigation to the selected local group chat
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
