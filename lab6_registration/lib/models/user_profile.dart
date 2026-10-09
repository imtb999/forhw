// Only profile details belong in the UI model. Passwords are not stored here.
class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.role,
  });

  final String fullName;
  final String email;
  final String role;
}
