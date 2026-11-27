import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/diary_storage.dart';
import '../models/diary_entry.dart';
import '../models/geo_fix.dart';
import '../services/location_service.dart';
import '../services/photo_service.dart';
import '../widgets/photo_preview.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({
    super.key,
    required this.storage,
    required this.photoService,
    required this.locationService,
  });

  final DiaryStorage storage;
  final PhotoService photoService;
  final LocationService locationService;

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final _caption = TextEditingController();
  late List<DiaryEntry> _entries;
  String? _photoPath;
  GeoFix? _fix;
  bool _locating = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _entries = widget.storage.load();
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  // ---------- Photo ----------

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final path = await widget.photoService.pick(source);
      if (path == null || !mounted) return; // user cancelled
      setState(() => _photoPath = path);
      // Geotag automatically right after the photo is taken.
      await _fetchLocation();
    } on PhotoException catch (e) {
      if (!mounted) return;
      switch (e.reason) {
        case PhotoFailure.denied:
          _snack('Camera permission was denied.');
        case PhotoFailure.permanentlyDenied:
          await _settingsDialog(
            title: 'Access blocked',
            message:
                'Camera or photo access was denied permanently '
                '("Don\'t ask again"). Enable it in the app settings.',
            onOpen: widget.photoService.openSettings,
          );
        case PhotoFailure.unavailable:
          _snack(
            source == ImageSource.camera
                ? 'Camera is not available on this device.'
                : 'Could not open the photo library.',
          );
      }
    }
  }

  // ---------- GPS ----------

  Future<void> _fetchLocation() async {
    if (_locating) return;
    setState(() => _locating = true);
    LocationFailure? failure;
    try {
      final fix = await widget.locationService.getCurrentLocation();
      if (mounted) setState(() => _fix = fix);
    } on LocationException catch (e) {
      failure = e.reason;
    } finally {
      // Stop the spinner before any dialog is shown.
      if (mounted) setState(() => _locating = false);
    }
    if (failure != null && mounted) {
      switch (failure) {
        case LocationFailure.serviceDisabled:
          await _settingsDialog(
            title: 'Location is off',
            message: 'Turn on device GPS / Location Services to geotag photos.',
            onOpen: widget.locationService.openLocationSettings,
          );
        case LocationFailure.denied:
          _snack('Location permission denied. The photo will have no GPS tag.');
        case LocationFailure.deniedForever:
          await _settingsDialog(
            title: 'Location permission blocked',
            message:
                'Location was denied with "Don\'t ask again". '
                'The app cannot ask again, enable it in the app settings.',
            onOpen: widget.locationService.openAppSettings,
          );
        case LocationFailure.timeout:
          _snack('GPS timeout. Move closer to a window and try again.');
        case LocationFailure.unknown:
          _snack('Could not get the location.');
      }
    }
  }

  // ---------- Diary ----------

  Future<void> _saveEntry() async {
    final path = _photoPath;
    final caption = _caption.text.trim();
    if (path == null) return _snack('Take or pick a photo first.');
    if (caption.isEmpty) return _snack('Write a caption.');
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      final savedPath = await widget.photoService.persist(path, id);
      final entry = DiaryEntry(
        id: id,
        imagePath: savedPath,
        caption: caption,
        createdAt: DateTime.now(),
        latitude: _fix?.latitude,
        longitude: _fix?.longitude,
        altitude: _fix?.altitude,
        accuracy: _fix?.accuracy,
      );
      final updated = [entry, ..._entries];
      await widget.storage.save(updated);
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      setState(() {
        _entries = updated;
        _photoPath = null;
        _fix = null;
        _caption.clear();
      });
      _snack('Saved to diary.');
    } catch (_) {
      _snack('Could not save the entry.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteEntry(DiaryEntry entry) async {
    final updated = _entries.where((e) => e.id != entry.id).toList();
    setState(() => _entries = updated);
    await widget.storage.save(updated);
    await widget.photoService.delete(entry.imagePath);
  }

  // ---------- Helpers ----------

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _settingsDialog({
    required String title,
    required String message,
    required Future<bool> Function() onOpen,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.settings_suggest_outlined),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Not now'),
          ),
          FilledButton(
            key: const Key('open_settings'),
            onPressed: () {
              Navigator.pop(ctx);
              onOpen();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_camera),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Narxoz Photo Journal',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PhotoPreview(path: _photoPath),
                const SizedBox(height: 16),
                _LocationCard(fix: _fix, locating: _locating),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        key: const Key('take_photo'),
                        onPressed: () => _pickPhoto(ImageSource.camera),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: const Text('Take Photo'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        key: const Key('pick_gallery'),
                        onPressed: () => _pickPhoto(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Pick Gallery'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  key: const Key('fetch_gps'),
                  onPressed: _locating ? null : _fetchLocation,
                  icon: _locating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(
                    _locating
                        ? 'Acquiring GPS lock...'
                        : 'Fetch Current GPS Location',
                  ),
                ),
                const Divider(height: 32),
                TextField(
                  key: const Key('caption_field'),
                  controller: _caption,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _saveEntry(),
                  decoration: const InputDecoration(
                    labelText: 'Caption',
                    hintText: 'Campus Quad at Narxoz',
                    prefixIcon: Icon(Icons.edit_note),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  key: const Key('save_entry'),
                  onPressed: _saving ? null : _saveEntry,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('SAVE ENTRY TO DIARY'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Diary Entries (${_entries.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_entries.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      'No entries yet. Capture your first moment!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.colorScheme.outline),
                    ),
                  )
                else
                  for (final entry in _entries)
                    Dismissible(
                      key: ValueKey(entry.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        color: theme.colorScheme.errorContainer,
                        child: const Icon(Icons.delete_outline),
                      ),
                      onDismissed: (_) => _deleteEntry(entry),
                      child: _EntryTile(entry: entry),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.fix, required this.locating});

  final GeoFix? fix;
  final bool locating;

  @override
  Widget build(BuildContext context) {
    final f = fix;
    String v(String Function(GeoFix) read) => f == null ? '—' : read(f);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              children: [
                _InfoRow(
                  icon: Icons.place_outlined,
                  label: 'Latitude',
                  value: v((f) => f.latitude.toStringAsFixed(6)),
                ),
                _InfoRow(
                  icon: Icons.place_outlined,
                  label: 'Longitude',
                  value: v((f) => f.longitude.toStringAsFixed(6)),
                ),
                _InfoRow(
                  icon: Icons.terrain_outlined,
                  label: 'Altitude',
                  value: v((f) => '${f.altitude.toStringAsFixed(1)} m'),
                ),
                _InfoRow(
                  icon: Icons.gps_fixed,
                  label: 'Accuracy',
                  value: v((f) => '± ${f.accuracy.toStringAsFixed(1)} m'),
                ),
                _InfoRow(
                  icon: Icons.schedule,
                  label: 'Timestamp',
                  value: v((f) => formatDateTime(f.timestamp)),
                ),
              ],
            ),
            if (locating)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          SizedBox(width: 96, child: Text('$label:')),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFeatures: [FontFeature.tabularFigures()],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry});

  final DiaryEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(entry.imagePath),
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            cacheWidth: 192,
            errorBuilder: (_, _, _) => Container(
              width: 64,
              height: 64,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
        title: Text(
          entry.caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${entry.coordinatesLabel}'
          '${entry.accuracy != null ? '  ± ${entry.accuracy!.toStringAsFixed(0)} m' : ''}\n'
          '${formatDateTime(entry.createdAt)}',
        ),
        isThreeLine: true,
      ),
    );
  }
}
