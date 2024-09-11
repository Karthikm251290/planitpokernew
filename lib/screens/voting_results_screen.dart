import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VotingResultsScreen extends StatelessWidget {
  final String roomId;
  final String storyId;

  VotingResultsScreen({required this.roomId, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voting Results'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .collection('stories')
            .doc(storyId)
            .collection('votes')
            .snapshots(),
        builder: (ctx, voteSnapshot) {
          if (voteSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final votes = voteSnapshot.data!.docs;
          if (votes.isEmpty) {
            return Center(child: Text('No votes submitted yet.'));
          }

          final List<double> voteValues = [];
          votes.forEach((vote) {
            final voteValue = vote['vote'];
            if (voteValue != '?') {
              voteValues.add(double.tryParse(voteValue) ?? 0);
            }
          });

          final averageVote = voteValues.isNotEmpty
              ? (voteValues.reduce((a, b) => a + b) / voteValues.length)
              : 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Voting Results:'),
                SizedBox(height: 20),
                Text('Number of Votes: ${votes.length}'),
                Text('Average Vote: ${averageVote.toStringAsFixed(1)}'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: votes.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text('Player ${index + 1}'),
                      subtitle: Text('Vote: ${votes[index]['vote']}'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
