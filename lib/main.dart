import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:planitpoker/screens/auth_screen.dart';
import 'package:planitpoker/screens/create_room_screen.dart';
import 'package:planitpoker/screens/voting_screen.dart';
import 'package:planitpoker/screens/create_story_screen.dart';
import 'package:planitpoker/screens/voting_results_screen.dart';
import 'firebase_options.dart'; // Import the generated firebase_options.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure Firebase is initialized before running the app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planit Poker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Initial route
      initialRoute: '/',
      // Define routes for the app
      routes: {
        '/': (context) => AuthScreen(), // Default screen (authentication)
        '/createRoom': (context) => CreateRoomScreen(), // Room creation screen
        '/createStory': (context) => CreateStoryScreen(
            roomId: 'sampleRoomId'), // Story creation with roomId
        '/voting': (context) => VotingScreen(
            roomId: 'sampleRoomId',
            storyId: 'sampleStoryId'), // Voting screen with room and story IDs
        '/results': (context) => VotingResultsScreen(
            roomId: 'sampleRoomId',
            storyId: 'sampleStoryId'), // Voting results screen
      },
    );
  }
}
