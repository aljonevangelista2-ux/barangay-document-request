import 'package:flutter/material.dart';
import '../constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resident Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 48,
            backgroundColor: lightBlue,
            child: Icon(Icons.person, size: 55, color: primaryBlue),
          ),
          const SizedBox(height: 14),
          const Text(
            'Resident Account',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Barangay Document Request System',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 28),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Full Name'),
                  subtitle: Text('Not yet configured'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text('Address'),
                  subtitle: Text('Not yet configured'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.phone_outlined),
                  title: Text('Contact Number'),
                  subtitle: Text('Not yet configured'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline, color: primaryBlue),
              title: Text('About the Application'),
              subtitle: Text(
                'A mobile system for submitting and tracking barangay document requests.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
