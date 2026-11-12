class Note {
  final String id;
  final String title;
  final String date;
  String? content; // Disimpan terpisah di secure storage

  Note({
    required this.id,
    required this.title,
    required this.date,
    this.content,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        date: json['date'],
      );
}