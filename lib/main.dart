import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '역류성 식도염 해방일지',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7BB4E3),
          secondary: const Color(0xFFA5D6A7),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 그라데이션 배경 적용
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFE8F5E9)], // 연한 파란색에서 연한 녹색으로
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 글래스모피즘 앱바
              _buildGlassAppBar(),

              // 메인 콘텐츠
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // 마스코트와 환영 메시지
                    _buildMascot(),
                    const SizedBox(height: 8),
                    const Text(
                      '오늘 어떠세요?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      '증상을 기록하고 건강을 관리해보세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 여기에 추가 콘텐츠가 들어갑니다

                    // HomePage 클래스 내부에 추가할 코드입니다

// 빠른 액션 버튼 (기록하기, 달력 보기)
                    Row(
                      children: [
                        Expanded(
                          child: _buildGradientButton(
                            '오늘 기록하기',
                            Icons.add_circle_outline,
                            [const Color(0xFF1E88E5), const Color(0xFF42A5F5)],
                            () {
                              // 기록 페이지로 이동하는 코드
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGradientButton(
                            '달력 보기',
                            Icons.calendar_today,
                            [const Color(0xFF66BB6A), const Color(0xFF81C784)],
                            () {
                              // 달력 페이지로 이동하는 코드
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 최근 상태 요약 카드
                    _buildGlassCard(
                      '최근 상태 요약',
                      '지난 7일간의 증상 요약',
                      const Color(0xFF1E88E5),
                      Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: _buildChart(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLegendItem('가슴쓰림', const Color(0xFF1E88E5)),
                              const SizedBox(width: 16),
                              _buildLegendItem('역류', const Color(0xFF66BB6A)),
                              const SizedBox(width: 16),
                              _buildLegendItem('소화불량', const Color(0xFFFFB74D)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    _buildGlassCard(
                      '최근 기록',
                      '최근 입력한 기록들',
                      const Color(0xFF66BB6A),
                      Column(
                        children: [
                          _buildRecentEntry(
                            '2023년 04월 15일 (토)',
                            ['가슴 쓰림', '목 아픔'],
                            '좋음',
                            '오늘은 증상이 경미했습니다. 저녁에 매운 음식을 피했더니 효과가 있었습니다.',
                            const Color(0xFF66BB6A),
                          ),
                          const SizedBox(height: 12),
                          _buildRecentEntry(
                            '2023년 04월 14일 (금)',
                            ['가슴 쓰림', '역류'],
                            '보통',
                            '점심에 커피를 마신 후 증상이 악화되었습니다.',
                            const Color(0xFFFFB74D),
                          ),
                          const SizedBox(height: 12),
                          _buildRecentEntry(
                            '2023년 04월 13일 (목)',
                            ['가슴 쓰림', '역류', '소화불량'],
                            '나쁨',
                            '오늘은 증상이 심했습니다. 취침 전 간식을 먹은 것이 원인인 것 같습니다.',
                            const Color(0xFFEF5350),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 글래스모피즘 앱바
  Widget _buildGlassAppBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 60,
          color: Colors.white.withOpacity(0.7),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // 앱 로고
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E88E5), Color(0xFF66BB6A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'R',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 앱 타이틀 (그라데이션 텍스트)
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF66BB6A)],
                ).createShader(bounds),
                child: const Text(
                  '역류식도염 친구',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white, // ShaderMask를 위해 흰색으로 설정
                  ),
                ),
              ),
              const Spacer(),
              // 설정 버튼
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Color(0xFF1E88E5),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 마스코트 캐릭터
  Widget _buildMascot() {
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

// 그라데이션 버튼 위젯
Widget _buildGradientButton(
  String text,
  IconData icon,
  List<Color> colors,
  VoidCallback onPressed,
) {
  return Container(
    height: 80,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: colors[0].withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// 글래스 카드 위젯
Widget _buildGlassCard(
    String title, String subtitle, Color color, Widget content) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    ),
  );
}

// 범례 아이템
Widget _buildLegendItem(String text, Color color) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 4),
      Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF757575),
        ),
      ),
    ],
  );
}

// 차트 위젯 (간단한 구현)
Widget _buildChart() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartBar(['4/10', 3, 2, 1]),
              _buildChartBar(['4/11', 2, 1, 0]),
              _buildChartBar(['4/12', 2, 3, 2]),
              _buildChartBar(['4/13', 3, 2, 1]),
              _buildChartBar(['4/14', 1, 0, 0]),
              _buildChartBar(['4/15', 2, 1, 1]),
              _buildChartBar(['4/16', 3, 2, 2]),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('4/10',
                style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            Text('4/11',
                style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            Text('4/12',
                style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            Text('4/13',
                style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            Text('4/14',
                style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            Text('4/15',
                style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            Text('4/16',
                style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ],
    ),
  );
}

// 차트 바
Widget _buildChartBar(List<dynamic> data) {
  String date = data[0] as String;
  int value1 = data[1] as int;
  int value2 = data[2] as int;
  int value3 = data[3] as int;

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 24,
        height: value1 * 20.0,
        decoration: const BoxDecoration(
          color: Color(0xFF1E88E5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ),
      Container(
        width: 24,
        height: value2 * 20.0,
        decoration: const BoxDecoration(
          color: Color(0xFF66BB6A),
        ),
      ),
      Container(
        width: 24,
        height: value3 * 20.0,
        decoration: const BoxDecoration(
          color: Color(0xFFFFB74D),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
        ),
      ),
    ],
  );
}

// 최근 기록 항목 위젯
Widget _buildRecentEntry(
  String date,
  List<String> symptoms,
  String status,
  String notes,
  Color statusColor,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFF1E88E5).withOpacity(0.1),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    statusColor,
                    statusColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: symptoms.map((symptom) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF1E88E5).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                symptom,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            );
          }).toList(),
        ),
        if (notes.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              notes,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
