import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryManagementScreen extends StatefulWidget {
  final String roomId;

  StoryManagementScreen({required this.roomId});

  @override
  _StoryManagementScreenState createState() => _StoryManagementScreenState();
}

class _StoryManagementScreenState extends State<StoryManagementScreen> {
  final _storyController = TextEditingController();
  bool _isEditing = false;
  String? _editingStoryId;

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  Future<void> _addStory() async {
    if (_storyController.text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('stories')
        .add({
      'description': _storyController.text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _storyController.clear();
  }

  Future<void> _updateStory(String storyId) async {
    if (_storyController.text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('stories')
        .doc(storyId)
        .update({'description': _storyController.text});

    setState(() {
      _isEditing = false;
      _editingStoryId = null;
    });

    _storyController.clear();
  }

  Future<void> _deleteStory(String storyId) async {
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('stories')
        .doc(storyId)
        .delete();
  }

  Future<void> _assignStoryForVoting(String storyId) async {
    // Logic to navigate to the voting screen with the selected story
    Navigator.pushNamed(
      context,
      '/voting',
      arguments: {
        'roomId': widget.roomId,
        'storyId': storyId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Stories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _storyController,
                    decoration: InputDecoration(
                      labelText: _isEditing ? 'Edit Story' : 'New Story',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_isEditing ? Icons.save : Icons.add),
                  onPressed: _isEditing
                      ? () => _updateStory(_editingStoryId!)
                      : _addStory,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(widget.roomId)
                  .collection('stories')
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final stories = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    final storyId = story.id;
                    final description = story['description'];

                    return ListTile(
                      title: Text(description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                                _editingStoryId = storyId;
                                _storyController.text = description;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteStory(storyId),
                          ),
                          IconButton(
                            icon: Icon(Icons.play_arrow),
                            onPressed: () => _assignStoryForVoting(storyId),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
