class UserData {
  final String id;
  final String name;
  final String email;
  final String attendanceIn;
  final String attendanceOut;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.attendanceIn,
    required this.attendanceOut,
  });

  // Konversi ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'attendance_in': attendanceIn,
      'attendance_out': attendanceOut,
    };
  }

  // Membaca data dari Map
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      attendanceIn: map['attendance_in'] ?? false,
      attendanceOut: map['attendance_out'] ?? false,
    );
  }
}
