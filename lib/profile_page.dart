import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';

class ProfilePage extends StatelessWidget {
  User user;
  final AuthService _authService = AuthService();

  ProfilePage({super.key, required this.user});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
        future: _authService.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Failed to load user data.'));
          }

          final userData = snapshot.data!.data()!;
          final name = userData['name'] ?? 'Unknown';
          final email = user.email ?? 'Unknown';
          final createdAt = (userData['created_at'] as Timestamp?)?.toDate();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Full Name: $name', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Email: $email'),
                const SizedBox(height: 8),
                Text('Member Since: ${createdAt != null ? createdAt.toLocal().toString().split('.')[0] : 'Unknown'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
