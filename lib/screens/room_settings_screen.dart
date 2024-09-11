import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomSettingsScreen extends StatefulWidget {
  final String roomId;

  RoomSettingsScreen({required this.roomId});

  @override
  _RoomSettingsScreenState createState() => _RoomSettingsScreenState();
}

class _RoomSettingsScreenState extends State<RoomSettingsScreen> {
  bool showIndividualVotes = true;
  bool allowVoteChange = false;
  bool useCountdownTimer = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final roomDoc = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .get();

    if (roomDoc.exists) {
      final data = roomDoc.data()!;
      setState(() {
        showIndividualVotes = data['showIndividualVotes'] ?? true;
        allowVoteChange = data['allowVoteChange'] ?? false;
        useCountdownTimer = data['useCountdownTimer'] ?? false;
      });
    }
  }

  void _updateSettings() {
    FirebaseFirestore.instance.collection('rooms').doc(widget.roomId).update({
      'showIndividualVotes': showIndividualVotes,
      'allowVoteChange': allowVoteChange,
      'useCountdownTimer': useCountdownTimer,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Show individual votes'),
            value: showIndividualVotes,
            onChanged: (val) {
              setState(() {
                showIndividualVotes = val;
              });
            },
          ),
          SwitchListTile(
            title: Text('Allow players to change votes after scores shown'),
            value: allowVoteChange,
            onChanged: (val) {
              setState(() {
                allowVoteChange = val;
              });
            },
          ),
          SwitchListTile(
            title: Text('Use a countdown timer'),
            value: useCountdownTimer,
            onChanged: (val) {
              setState(() {
                useCountdownTimer = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
