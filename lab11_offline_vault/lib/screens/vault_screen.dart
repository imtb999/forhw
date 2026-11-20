import 'package:flutter/material.dart';

import '../data/vault_storage.dart';
import '../models/note_item.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({
    super.key,
    required this.storage,
    required this.isDark,
    required this.onDarkModeChanged,
  });

  final VaultStorage storage;
  final bool isDark;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  late String _displayName;
  late List<NoteItem> _notes;

  @override
  void initState() {
    super.initState();
    _displayName = widget.storage.loadDisplayName();
    _notes = widget.storage.loadNotes();
    if (_displayName != VaultStorage.defaultName) {
      _nameController.text = _displayName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _displayName = name);
    await widget.storage.saveDisplayName(name);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Saved name: $name')));
  }

  void _addNote() {
    final title = _noteController.text.trim();
    if (title.isEmpty) return;
    final note = NoteItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      dateText: _formatDate(DateTime.now()),
    );
    _noteController.clear();
    _update([note, ..._notes]); // prepend
  }

  void _toggleNote(NoteItem note) => _update([
    for (final n in _notes)
      n.id == note.id ? n.copyWith(isCompleted: !n.isCompleted) : n,
  ]);

  void _deleteNote(NoteItem note) =>
      _update(_notes.where((n) => n.id != note.id).toList());

  /// Every change: update UI, then encode the whole list and save it.
  void _update(List<NoteItem> notes) {
    setState(() => _notes = notes);
    widget.storage.saveNotes(notes);
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year}, '
        '${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final done = _notes.where((n) => n.isCompleted).length;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, $_displayName', key: const Key('header_name')),
        actions: [
          Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
          Switch(
            key: const Key('dark_mode_switch'),
            value: widget.isDark,
            onChanged: widget.onDarkModeChanged,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                key: const Key('name_field'),
                                controller: _nameController,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _saveName(),
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton(
                              key: const Key('save_name_button'),
                              onPressed: _saveName,
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('note_field'),
                        controller: _noteController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addNote(),
                        decoration: const InputDecoration(
                          labelText: 'New note',
                          prefixIcon: Icon(Icons.edit_note),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      key: const Key('add_note_button'),
                      onPressed: _addNote,
                      icon: const Icon(Icons.add),
                      tooltip: 'Add note',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Notes: ${_notes.length} · Completed: $done',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                if (_notes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 56,
                          color: scheme.outline,
                        ),
                        const SizedBox(height: 8),
                        const Text('No notes yet. Add your first one!'),
                      ],
                    ),
                  )
                else
                  for (final note in _notes)
                    Card(
                      key: ValueKey(note.id),
                      child: ListTile(
                        leading: Checkbox(
                          value: note.isCompleted,
                          onChanged: (_) => _toggleNote(note),
                        ),
                        title: Text(
                          note.title,
                          style: note.isCompleted
                              ? TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: scheme.outline,
                                )
                              : null,
                        ),
                        subtitle: Text(note.dateText),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Delete note',
                          onPressed: () => _deleteNote(note),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
