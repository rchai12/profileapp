import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final AuthService _authService = AuthService();

  ProfilePage({super.key, required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _newEmailController;
  late TextEditingController _newPasswordController;

  bool _isEditingName = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController();
    _newEmailController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _newEmailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateName() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget._authService.updateName(_nameController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget._authService.updateEmail(
        email: widget.user.email!,
        currentPassword: _passwordController.text.trim(),
        newEmail: _newEmailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget._authService.updatePassword(
        email: widget.user.email!,
        currentPassword: _passwordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _isEditingName
                ? TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                  )
                : ListTile(
                    title: Text('Full Name: ${_nameController.text}'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEditingName = true;
                        });
                      },
                    ),
                  ),
            const SizedBox(height: 16),
            _isEditingEmail
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _newEmailController,
                        decoration: InputDecoration(labelText: 'New Email'),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Current Password'),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _updateEmail,
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text('Update Email'),
                      ),
                    ],
                  )
                : ListTile(
                    title: Text('Email: ${widget.user.email}'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEditingEmail = true;
                        });
                      },
                    ),
                  ),
            const SizedBox(height: 16),
            _isEditingPassword
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(labelText: 'New Password'),
                        obscureText: true,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Current Password'),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _updatePassword,
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text('Update Password'),
                      ),
                    ],
                  )
                : ListTile(
                    title: Text('Password: ********'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEditingPassword = true;
                        });
                      },
                    ),
                  ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateName,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Save Name'),
            ),
          ],
        ),
      ),
    );
  }
}
