import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VotingResultsScreen extends StatefulWidget {
  final String roomId;
  final String storyId;

  VotingResultsScreen({required this.roomId, required this.storyId});

  @override
  _VotingResultsScreenState createState() => _VotingResultsScreenState();
}

class _VotingResultsScreenState extends State<VotingResultsScreen> {
  int averageVote = 0;
  Map<String, int> individualVotes = {};

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    final storyDoc = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('stories')
        .doc(widget.storyId)
        .get();

    if (storyDoc.exists && storyDoc.data()!.containsKey('points')) {
      setState(() {
        averageVote = storyDoc.data()!['points'];
      });
    }

    final votesSnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('stories')
        .doc(widget.storyId)
        .collection('votes')
        .get();

    final Map<String, int> votes = {};
    votesSnapshot.docs.forEach((doc) {
      votes[doc.id] = doc.data()['vote'] as int;
    });

    setState(() {
      individualVotes = votes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voting Results'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Average Vote: $averageVote',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Individual Votes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: individualVotes.keys.length,
              itemBuilder: (context, index) {
                String userId = individualVotes.keys.elementAt(index);
                int vote = individualVotes[userId]!;
                return ListTile(
                  title: Text('User $userId'),
                  subtitle: Text('Voted: $vote'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
