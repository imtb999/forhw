import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import 'catalog_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _confirmKey = GlobalKey<FormFieldState<String>>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String _role = 'Student';
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _register() {
    setState(() {
      _submitted = true;
    });
    // The checkbox is also a FormField, so one validation checks everything.
    if (!_formKey.currentState!.validate()) return;

    final profile = UserProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      role: _role,
    );
    debugPrint(
      jsonEncode({
        'fullName': profile.fullName,
        'email': profile.email,
        'role': profile.role,
        'acceptedTerms': true,
        'password': '[hidden]',
      }),
    );
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful! Welcome to Sneaker Store.'),
      ),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => CatalogScreen(profile: profile)),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
      errorMaxLines: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SNEAKER / STORE')),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Form(
                key: _formKey,
                autovalidateMode: _submitted
                    ? AutovalidateMode.always
                    : AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'JOIN THE EVERYDAY CLUB',
                      style: TextStyle(letterSpacing: 2, color: Colors.brown),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Create your profile',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('A few details, then your next pair awaits.'),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('fullName'),
                      controller: _nameController,
                      decoration: _decoration(
                        'Full Name',
                        Icons.person_outline,
                      ),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Enter your full name.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('email'),
                      controller: _emailController,
                      decoration: _decoration('Email', Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'Enter your email.';
                        if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                            .hasMatch(email)) {
                          return 'Use an email like name@narxoz.kz.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('password'),
                      controller: _passwordController,
                      decoration: _decoration('Password', Icons.lock_outline),
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a password.';
                        }
                        if (value.length < 6) {
                          return 'Use at least 6 characters.';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        // A password edit must also recheck the confirmation.
                        if (_submitted || _confirmController.text.isNotEmpty) {
                          _confirmKey.currentState?.validate();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: _confirmKey,
                      controller: _confirmController,
                      decoration: _decoration(
                        'Confirm Password',
                        Icons.lock_outline,
                      ),
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _register(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm your password.';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords must match exactly.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      key: const Key('role'),
                      initialValue: _role,
                      isExpanded: true,
                      decoration: _decoration('Role', Icons.badge_outlined),
                      items: ['Student', 'Teacher', 'Developer'].map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _role = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    FormField<bool>(
                      initialValue: false,
                      validator: (value) => value == true
                          ? null
                          : 'Accept the Terms and Conditions to continue.',
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              key: const Key('terms'),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text(
                                'I accept the Terms and Conditions',
                              ),
                              value: field.value,
                              onChanged: (value) {
                                field.didChange(value ?? false);
                                field.validate();
                              },
                            ),
                            if (field.hasError)
                              Text(
                                field.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      key: const Key('register'),
                      onPressed: _register,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Classroom demo: profile details stay in memory. No online account is created.',
                      style: TextStyle(color: Colors.brown),
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
