class UserData {
  final String id;
  final String name;
  final String email;
  final int totalTask;
  final int needToSign;
  final int waitingForTheOthers;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    this.totalTask = 0,
    this.needToSign = 0,
    this.waitingForTheOthers = 0,
  });

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
