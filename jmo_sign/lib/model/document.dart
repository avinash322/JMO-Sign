class Document {
  String id;
  String title;
  String date;
  String target;
  String author1;
  String? author2; // Optional author 2
  String? author3;
  String image; // Optional author 3

  // Constructor
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

  // Method to convert Document to Map (for Firestore or other DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date, // converting DateTime to string
      'target': target,
      'author_1': author1,
      'author_2': author2,
      'author_3': author3,
      "image": image
    };
  }

  // Method to create Document from Map (for Firestore or other DB)
  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? "",
      target: map['target'] ?? '',
      author1: map['author_1'] ?? '',
      author2: map['author_2'], // can be null
      author3: map['author_3'], // can be null
      image: map["image"] ?? "",
    );
  }
}
