class Document {
  String id;
  String title;
  String date;
  String target;
  String author1;
  String? author2;
  String? author3;
  String image;

  Document({
    required this.id,
    required this.title,
    required this.date,
    required this.target,
    required this.author1,
    this.author2,
    this.author3,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'target': target,
      'author_1': author1,
      'author_2': author2,
      'author_3': author3,
      "image": image
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? "",
      target: map['target'] ?? '',
      author1: map['author_1'] ?? '',
      author2: map['author_2'],
      author3: map['author_3'],
      image: map["image"] ?? "",
    );
  }
}
