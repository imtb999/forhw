import 'dart:io';

import 'package:flutter/material.dart';

/// Rounded 4:3 preview box: the picked photo via Image.file, or a
/// camera placeholder when nothing is selected yet.
class PhotoPreview extends StatelessWidget {
  const PhotoPreview({super.key, required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Column(
      key: const Key('photo_placeholder'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.photo_camera_outlined, size: 64, color: scheme.outline),
        const SizedBox(height: 8),
        Text('No photo yet', style: TextStyle(color: scheme.outline)),
      ],
    );
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(20),
          ),
          child: path == null
              ? placeholder
              : Image.file(
                  File(path!),
                  key: const Key('photo_preview'),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => placeholder,
                ),
        ),
      ),
    );
  }
}
