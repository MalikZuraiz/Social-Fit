import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us',
            style: TextStyle(
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xff000221))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'If you have any questions or suggestions about our app, do not hesitate to contact us.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: const Text('mirzaasjad17@gmail.com'),
              onTap: () {
                // Open email app with pre-filled email
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: const Text('+92 323 9432407'),
              onTap: () {
                // Open phone app with pre-filled phone number
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Address'),
              subtitle: const Text('Naval Complex, E-8, Islamabad'),
              onTap: () {
                // Open map app with pre-filled address
              },
            ),
          ],
        ),
      ),
    );
  }
}
