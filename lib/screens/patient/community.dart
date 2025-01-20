import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Community')),
        body: Center(
          child: Text('You must be signed in to view this page.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Community Chat'),
      ),
      body: Column(
        children: [
          // Display Messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('community_chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data?.docs ?? [];
                if (messages.isEmpty) {
                  return Center(child: Text('No messages yet. Start the conversation!'));
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(message['role'] == 'doctor' ? 'D' : 'P'),
                      ),
                      title: Text(message['senderName'] ?? 'Unknown'),
                      subtitle: Text(message['message'] ?? ''),
                      trailing: Text(
                        message['timestamp'] != null
                            ? DateTime.fromMillisecondsSinceEpoch(
                                  message['timestamp'].seconds * 1000)
                                .toString()
                            : '',
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      try {
                        await FirebaseFirestore.instance.collection('community_chats').add({
                          'message': _messageController.text.trim(),
                          'senderId': user!.uid,
                          'senderName': user?.displayName ?? 'Anonymous',
                          'role': await getUserRole(user!.uid),
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        _messageController.clear();
                      } catch (e) {
                        print('Error sending message: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to send message. Please try again.')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fetch User Role from Firestore
  Future<String> getUserRole(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return (doc.data() ?? {})['type'] ?? 'patient';
    } catch (e) {
      print('Error fetching user role: $e');
      return 'patient'; // Default to patient
    }
  }
}
