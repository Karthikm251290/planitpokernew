import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VotingScreen extends StatefulWidget {
  final String roomId;
  final String storyId;

  VotingScreen({required this.roomId, required this.storyId});

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final List<String> _cardValues = [
    '0',
    '1/2',
    '1',
    '2',
    '3',
    '5',
    '8',
    '13',
    '21',
    '?'
  ];
  String? _selectedVote;
  bool _voteSubmitted = false;

  void _submitVote() async {
    if (_selectedVote == null) {
      _showErrorDialog('Please select a vote.');
      return;
    }

    try {
      final userId =
          'your_user_id'; // Replace with actual user ID (use Firebase Auth if necessary)
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .collection('stories')
          .doc(widget.storyId)
          .collection('votes')
          .doc(userId)
          .set({'vote': _selectedVote});

      setState(() {
        _voteSubmitted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vote submitted successfully!')),
      );
    } catch (error) {
      _showErrorDialog('Failed to submit vote. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Vote for the current story:'),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: _cardValues.map((value) {
                return ChoiceChip(
                  label: Text(value),
                  selected: _selectedVote == value,
                  onSelected: _voteSubmitted
                      ? null
                      : (selected) {
                          setState(() {
                            _selectedVote = value;
                          });
                        },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _voteSubmitted ? null : _submitVote,
              child: Text(_voteSubmitted ? 'Vote Submitted' : 'Submit Vote'),
            ),
          ],
        ),
      ),
    );
  }
}
