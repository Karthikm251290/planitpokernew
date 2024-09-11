import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomHistoryScreen extends StatelessWidget {
  final String roomId;

  RoomHistoryScreen({required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .collection('stories')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final stories = snapshot.data!.docs;

          if (stories.isEmpty) {
            return Center(
              child: Text('No stories in this room yet.'),
            );
          }

          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final storyData = stories[index].data() as Map<String, dynamic>;
              final storyTitle = storyData['title'];
              final storyPoints = storyData['points'];

              return ListTile(
                title: Text('Story: $storyTitle'),
                subtitle: Text('Story Points: $storyPoints'),
              );
            },
          );
        },
      ),
    );
  }
}
