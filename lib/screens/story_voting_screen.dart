import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryVotingScreen extends StatefulWidget {
  final String roomId;
  final String storyId;

  StoryVotingScreen({required this.roomId, required this.storyId});

  @override
  _StoryVotingScreenState createState() => _StoryVotingScreenState();
}

class _StoryVotingScreenState extends State<StoryVotingScreen> {
  List<int> fibonacciNumbers = [0, 1, 2, 3, 5, 8, 13, 20, 40, 100];
  int? selectedVote;

  void _submitVote(int vote) {
    setState(() {
      selectedVote = vote;
    });

    FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('stories')
        .doc(widget.storyId)
        .collection('votes')
        .doc('current_user_id') // Replace with actual user ID
        .set({
      'vote': vote,
      'votedAt': Timestamp.now(),
    });
  }

  Future<void> _revealVotes() async {
    final votesSnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('stories')
        .doc(widget.storyId)
        .collection('votes')
        .get();

    int totalVotes = 0;
    int totalVoters = 0;

    votesSnapshot.docs.forEach((doc) {
      totalVotes += doc.data()['vote'] as int;
      totalVoters += 1;
    });

    int averageVote = (totalVotes / totalVoters).round();

    FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('stories')
        .doc(widget.storyId)
        .update({'points': averageVote});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vote on Story'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select your estimate',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: fibonacciNumbers.map((number) {
              return ChoiceChip(
                label: Text(number.toString()),
                selected: selectedVote == number,
                onSelected: (selected) {
                  if (selected) {
                    _submitVote(number);
                  }
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await _revealVotes();
              Navigator.pop(context);
            },
            child: Text('Reveal Votes (Admin only)'),
          ),
        ],
      ),
    );
  }
}
