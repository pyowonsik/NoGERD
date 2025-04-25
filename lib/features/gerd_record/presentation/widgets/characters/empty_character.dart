import 'package:flutter/material.dart';

class EmptyCharacter extends StatelessWidget {
  const EmptyCharacter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            // 귀여운 일러스트레이션
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.7),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF66BB6A).withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 마스코트 변형 - 잠자는 표정
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE3F2FD),
                    ),
                  ),
                  // 눈 (감은 눈)
                  Positioned(
                    top: 40,
                    left: 30,
                    child: Container(
                      width: 12,
                      height: 2,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E88E5),
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 30,
                    child: Container(
                      width: 12,
                      height: 2,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E88E5),
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                  // 입 (z 표시)
                  Positioned(
                    top: 50,
                    right: 35,
                    child: Transform.rotate(
                      angle: -0.2,
                      child: const Text(
                        'z',
                        style: TextStyle(
                          color: Color(0xFF1E88E5),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 45,
                    right: 45,
                    child: Transform.rotate(
                      angle: -0.2,
                      child: const Text(
                        'z',
                        style: TextStyle(
                          color: Color(0xFF1E88E5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 42,
                    right: 53,
                    child: Transform.rotate(
                      angle: -0.2,
                      child: const Text(
                        'z',
                        style: TextStyle(
                          color: Color(0xFF1E88E5),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 메시지
            Text(
              '아직 기록이 없어요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '첫 번째 증상을 기록해보세요!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
