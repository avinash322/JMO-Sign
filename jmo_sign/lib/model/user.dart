class UserData {
  final String id;
  final String name;
  final String email;
  final int totalTask; // Jumlah total tugas yang dimiliki user
  final int needToSign; // Jumlah dokumen yang perlu ditandatangani user
  final int waitingForTheOthers; // Jumlah dokumen yang menunggu orang lain

  UserData({
    required this.id,
    required this.name,
    required this.email,
    this.totalTask = 0, // Nilai default
    this.needToSign = 0, // Nilai default
    this.waitingForTheOthers = 0, // Nilai default
  });

  // Konversi ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'total_task': totalTask,
      'need_to_sign': needToSign,
      'waiting_for_the_others': waitingForTheOthers,
    };
  }

  // Membaca data dari Map
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      totalTask: map['total_task'] ?? 0,
      needToSign: map['need_to_sign'] ?? 0,
      waitingForTheOthers: map['waiting_for_the_others'] ?? 0,
    );
  }
}
