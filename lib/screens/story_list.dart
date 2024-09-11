import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryList extends StatefulWidget {
  final String roomId;

  StoryList({required this.roomId});

  @override
  _StoryListState createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  final TextEditingController _storyController = TextEditingController();

  void _addStory() {
    if (_storyController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .collection('stories')
          .add({
        'description': _storyController.text,
        'points': null,
        'createdAt': Timestamp.now(),
      });
      _storyController.clear();
    }
  }

  void _deleteStory(String storyId) {
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('stories')
        .doc(storyId)
        .delete();
  }

  void _updateStoryPoints(String storyId, int points) {
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('stories')
        .doc(storyId)
        .update({
      'points': points,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _storyController,
            decoration: InputDecoration(
              labelText: 'Enter new task/story',
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: _addStory,
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('rooms')
                .doc(widget.roomId)
                .collection('stories')
                .orderBy('createdAt', descending: true)
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
                  final storyData = story.data() as Map<String, dynamic>;
                  final storyDescription = storyData['description'];
                  final storyPoints = storyData['points'];

                  return ListTile(
                    title: Text(storyDescription),
                    subtitle: storyPoints != null
                        ? Text('Points: $storyPoints')
                        : Text('No points assigned'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteStory(story.id),
                    ),
                    onTap: () {
                      // This would navigate to a screen where users can vote on this story
                      // or use a dialog to input story points.
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
