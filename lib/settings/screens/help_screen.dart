import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help',
            style: TextStyle(
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xff000221))),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildHelpCard(
            title: 'Using Simple Exercises',
            subtitle: 'Use exercises to improve your workouts.',
            icon: Icons.sports_gymnastics,
            onTap: () {
              // Navigate to A.I. Exercises help section
            },
          ),
          _buildHelpCard(
            title: 'Social Fit',
            subtitle: 'Connect with all your workout partners.',
            icon: Icons.social_distance,
            onTap: () {
              // Navigate to A.I. Exercises help section
            },
          ),
          _buildHelpCard(
            title: 'Using A.I. Exercises',
            subtitle:
                'Learn how to use A.I. exercises to improve your workouts.',
            icon: Icons.fitness_center,
            onTap: () {
              // Navigate to A.I. Exercises help section
            },
          ),
          _buildHelpCard(
            title: 'Navigating the App',
            subtitle: 'Find your way around the Social Fit App with ease.',
            icon: Icons.directions_run,
            onTap: () {
              // Navigate to Navigating the App help section
            },
          ),

          _buildHelpCard(
            title: 'Listen To Music',
            subtitle: 'Find the best music with exercise.',
            icon: Icons.music_note,
            onTap: () {
              // Navigate to Navigating the App help section
            },
          ),
          // Add more Card widgets for other help topics
        ],
      ),
    );
  }

  Widget _buildHelpCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.transparent, // Set card color to transparent
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade900,
            ],
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            size: 36.0,
            color: Colors.white, // Set icon color to white
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.black87, // Set title color to white
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
                color: Colors.white), // Set subtitle color to white
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
