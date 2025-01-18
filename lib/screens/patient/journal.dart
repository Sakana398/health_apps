import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Journal"),
        backgroundColor: Colors.lightBlueAccent,
        
      ),
      body: StreamBuilder(
        stream: _firestore.collection('journals').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final journalDocs = snapshot.data?.docs;

          if (journalDocs == null || journalDocs.isEmpty) {
            return const Center(
              child: Text(
                "No journal written yet.",
                style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
              ),
            );
          }

          return ListView.builder(
            itemCount: journalDocs.length,
            itemBuilder: (context, index) {
              final journal = journalDocs[index];
              return ListTile(
                title: Text(journal['title'] ?? "Untitled"),
                subtitle: Text(
                  journal['story'] ?? "No story provided.",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => JournalDetailScreen(journal: journal),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 178, 227, 250),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const WriteJournalScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WriteJournalScreen extends StatefulWidget {
  const WriteJournalScreen({super.key});

  @override
  State<WriteJournalScreen> createState() => _WriteJournalScreenState();
}

class _WriteJournalScreenState extends State<WriteJournalScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Write"),
        
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Title",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Add a title to this entry",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Story",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                controller: _storyController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Write something...",
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitJournal,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 178, 227, 250),
              ),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitJournal() async {
    if (_titleController.text.isEmpty || _storyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and story cannot be empty.")),
      );
      return;
    }

    try {
      await _firestore.collection('journals').add({
        'title': _titleController.text,
        'story': _storyController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.of(context).pop(); // Go back to the list screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving journal: $e")),
      );
    }
  }
}

class JournalDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot journal;

  const JournalDetailScreen({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(journal['title'] ?? "Untitled"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              journal['title'] ?? "Untitled",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              journal['story'] ?? "No story provided.",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
