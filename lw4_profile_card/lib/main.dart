import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Card',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollowing = false;
  bool isLiked = false;
  int likes = 0;

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likes += isLiked ? 1 : -1;
    });
  }

  void resetProfile() {
    setState(() {
      isFollowing = false;
      isLiked = false;
      likes = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), centerTitle: true),
      backgroundColor: const Color(0xFFF0F4FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 360,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      child: Icon(Icons.person, size: 64),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Temirlan',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Flutter student'),
                    const SizedBox(height: 12),
                    const Text(
                      'Learning to build mobile apps with Dart and Flutter.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text('Followers: ${isFollowing ? 1 : 0}'),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: toggleFollow,
                      icon: Icon(isFollowing ? Icons.check : Icons.person_add),
                      label: Text(isFollowing ? 'Following' : 'Follow'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: toggleLike,
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : null,
                      ),
                      label: Text('Likes: $likes'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: resetProfile,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
