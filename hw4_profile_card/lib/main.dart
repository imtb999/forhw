import 'package:flutter/material.dart';

void main() => runApp(const ProfileApp());

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Profile Card',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const ProfilePage(),
  );
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollowing = false;
  bool isLiked = false;
  int likes = 128;

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }
  void toggleLike() {}
  void reset() {}

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF4F3F8),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 380,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      child: Text('AL', style: TextStyle(fontSize: 32)),
                    ),
                    const SizedBox(height: 20),
                    const Text('Alex Lee',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const Text('@alexcreates'),
                    const SizedBox(height: 12),
                    const Text('Designer. Explorer. Coffee enthusiast.',
                      textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    Text('${2400 + (isFollowing ? 1 : 0)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text('Followers'),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: toggleFollow,
                      icon: Icon(isFollowing ? Icons.check : Icons.person_add),
                      label: Text(isFollowing ? 'Following' : 'Follow'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: toggleLike,
                      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                      label: Text('${isLiked ? 'Liked' : 'Like'} · $likes'),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: reset,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
