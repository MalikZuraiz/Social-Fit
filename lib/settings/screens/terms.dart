import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions',
            style: TextStyle(
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xff000221))),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, belong to us.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Changes to Terms and Conditions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We reserve the right to modify these terms and conditions at any time. If we do so, we will post the changes on this page and indicate at the top of this page the date these terms were last revised. Your continued use of the app after any such changes constitutes your acceptance of the new terms and conditions.',
              style: TextStyle(fontSize: 16.0),
            ),
            // Add more sections as needed
          ],
        ),
      ),
    );
  }
}
