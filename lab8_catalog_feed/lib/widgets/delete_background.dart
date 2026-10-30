import 'package:flutter/material.dart';

// Shown behind an item while it is swiped right-to-left.
class DeleteBackground extends StatelessWidget {
  const DeleteBackground({super.key, this.borderRadius = BorderRadius.zero});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.red, borderRadius: borderRadius),
      child: const Icon(Icons.delete, color: Colors.white, size: 28),
    );
  }
}
