import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateStoryScreen extends StatefulWidget {
  final String roomId;

  CreateStoryScreen({required this.roomId});

  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final _storyTitleController = TextEditingController();
  final _storyDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _saveStory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .collection('stories')
          .add({
        'title': _storyTitleController.text.trim(),
        'description': _storyDescriptionController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Story added successfully!')),
      );

      _storyTitleController.clear();
      _storyDescriptionController.clear();
    } catch (error) {
      _showErrorDialog('Failed to save story. Please try again.');
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
        title: Text('Create Story'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _storyTitleController,
                decoration: InputDecoration(labelText: 'Story Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a story title.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _storyDescriptionController,
                decoration: InputDecoration(labelText: 'Story Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a story description.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveStory,
                child: Text('Save Story'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _storyTitleController.dispose();
    _storyDescriptionController.dispose();
    super.dispose();
  }
}
