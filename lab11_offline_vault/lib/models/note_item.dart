class NoteItem {
  const NoteItem({
    required this.id,
    required this.title,
    required this.dateText,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String dateText;
  final bool isCompleted;

  NoteItem copyWith({bool? isCompleted}) => NoteItem(
    id: id,
    title: title,
    dateText: dateText,
    isCompleted: isCompleted ?? this.isCompleted,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dateText': dateText,
    'isCompleted': isCompleted,
  };

  factory NoteItem.fromJson(Map<String, dynamic> json) => NoteItem(
    id: json['id']?.toString() ?? '',
    title: json['title'] as String? ?? '',
    dateText: json['dateText'] as String? ?? '',
    isCompleted: json['isCompleted'] as bool? ?? false,
  );
}
