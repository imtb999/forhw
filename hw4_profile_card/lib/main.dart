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
  int likes = 128;

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }
  void like() {
    setState(() {
      likes++;
    });
  }
  void dislike() {
    setState(() {
      likes--;
    });
  }
  void reset() {
    setState(() {
      isFollowing = false;
      likes = 128;
    });
  }

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
                      child: Text('TB', style: TextStyle(fontSize: 32)),
                    ),
                    const SizedBox(height: 20),
                    const Text('Temirlan Baidash',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const Text('@imtb'),
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
                    Text('$likes',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text('Likes'),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: like,
                          icon: const Icon(Icons.thumb_up_outlined),
                          label: const Text('Like'),
                        ),
                        OutlinedButton.icon(
                          onPressed: dislike,
                          icon: const Icon(Icons.thumb_down_outlined),
                          label: const Text('Dislike'),
                        ),
                      ],
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
