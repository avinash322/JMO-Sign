import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CircularProgressDashboard extends StatelessWidget {
  // Nilai progres (misalnya 0.5 untuk 50%)
  final int number; // Angka yang ingin ditampilkan di dalam lingkaran

  const CircularProgressDashboard({
    Key? key,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150, // Pastikan ukuran cukup besar
        height: 150, // Pastikan ukuran cukup besar
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100, // Ukuran lebih besar
              height: 100, // Ukuran lebih besar
              child: CircularProgressIndicator(
                value: 0.85,
                strokeWidth: 8.0,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE4D00A)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF2E8B57), width: 3),
                  color: Color(0xFF2AAA8A),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
