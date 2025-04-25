import 'package:flutter/material.dart';

class MainCharacter extends StatelessWidget {
  const MainCharacter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.blue.shade100.withOpacity(0.3),
              Colors.green.shade100.withOpacity(0.1),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 애니메이션 효과 (실제 앱에서는 AnimatedContainer 사용)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.shade100.withOpacity(0.5),
                    Colors.green.shade100.withOpacity(0.2),
                  ],
                ),
              ),
            ),
            // 캐릭터 얼굴
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF8F9FA),
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE3F2FD),
              ),
            ),
            // 눈
            Positioned(
              top: 40,
              left: 30,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1E88E5),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 1,
                          right: 1,
                          child: Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 30,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1E88E5),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 1,
                          right: 1,
                          child: Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // 볼
            Positioned(
              top: 55,
              left: 25,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFCDD2).withOpacity(0.7),
                ),
              ),
            ),
            Positioned(
              top: 55,
              right: 25,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFCDD2).withOpacity(0.7),
                ),
              ),
            ),
            // 입
            Positioned(
              top: 65,
              left: 0,
              right: 0,
              child: Center(
                child: CustomPaint(
                  size: const Size(20, 10),
                  painter: SmilePainter(),
                ),
              ),
            ),
            // 위
            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 30,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF66BB6A).withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: CustomPaint(
                    size: const Size(30, 10),
                    painter: StomachPainter(),
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

// 웃는 표정 그리기
class SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF5252)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 위 그리기
class StomachPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
