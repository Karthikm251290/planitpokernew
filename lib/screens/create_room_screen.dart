import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateRoomScreen extends StatefulWidget {
  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _roomNameController = TextEditingController();
  String _roomType = 'Scrum'; // Default value
  bool _isLoading = false;

  Future<void> _createRoom() async {
    if (_roomNameController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final roomData = {
      'name': _roomNameController.text,
      'type': _roomType,
      'createdAt': Timestamp.now(), // Ensure Timestamp is from Firestore
    };

    try {
      await FirebaseFirestore.instance.collection('rooms').add(roomData);
      Navigator.of(context).pop();
    } catch (error) {
      // Handle any errors
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _roomNameController,
              decoration: InputDecoration(labelText: 'Room Name'),
            ),
            DropdownButton<String>(
              value: _roomType,
              onChanged: (newValue) {
                setState(() {
                  _roomType = newValue!;
                });
              },
              items: <String>['Scrum', 'Kanban']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _createRoom,
                    child: Text('Create Room'),
                  ),
          ],
        ),
      ),
    );
  }
}
