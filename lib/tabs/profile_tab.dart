import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late Future<Map<String, dynamic>> _userProfile;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userProfile = fetchUserProfile();
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    print(accessToken);

    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/auth/profile'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final userProfile = jsonDecode(response.body);
      final userId = userProfile['id'];

      final userResponse = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/users/$userId'),
      );

      if (userResponse.statusCode == 200) {
        return jsonDecode(userResponse.body);
      } else {
        throw Exception('Failed to load user profile');
      }
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(String email, String name) async {
    final userProfile = await fetchUserProfile();
    final userId = userProfile['id'];

    final response = await http.put(
      Uri.parse('https://api.escuelajs.co/api/v1/users/$userId'),
      body: jsonEncode({'email': email, 'name': name}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userProfile = snapshot.data!;
            _emailController.text = userProfile['email'];
            _nameController.text = userProfile['name'];
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userProfile['avatar']),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final updatedProfile = await updateUserProfile(_emailController.text, _nameController.text);
                        setState(() {
                          userProfile['email'] = updatedProfile['email'];
                          userProfile['name'] = updatedProfile['name'];
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User profile updated')));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user profile')));
                      }
                    },
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
