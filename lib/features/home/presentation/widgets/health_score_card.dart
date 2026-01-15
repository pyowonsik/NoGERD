import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:no_gerd/shared/shared.dart';

/// 건강 점수 카드
class HealthScoreCard extends StatefulWidget {
  final int score;
  final int? previousScore;
  final String? message;

  const HealthScoreCard({
    super.key,
    required this.score,
    this.previousScore,
    this.message,
  });

  @override
  State<HealthScoreCard> createState() => _HealthScoreCardState();
}

class _HealthScoreCardState extends State<HealthScoreCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.score.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _scoreColor {
    if (widget.score >= 80) return AppTheme.success;
    if (widget.score >= 60) return AppTheme.warning;
    return AppTheme.error;
  }

  String get _scoreLabel {
    if (widget.score >= 80) return '좋음';
    if (widget.score >= 60) return '보통';
    return '주의';
  }

  int get _scoreDiff {
    if (widget.previousScore == null) return 0;
    return widget.score - widget.previousScore!;
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              // 점수 원형 프로그레스
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: CustomPaint(
                      painter: _CircularProgressPainter(
                        progress: _scoreAnimation.value / 100,
                        color: _scoreColor,
                        backgroundColor: _scoreColor.withValues(alpha: 0.15),
                        strokeWidth: 10,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _scoreAnimation.value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _scoreColor,
                              ),
                            ),
                            Text(
                              _scoreLabel,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _scoreColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '건강 점수',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${widget.score}점',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        if (_scoreDiff != 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _scoreDiff > 0
                                  ? AppTheme.success.withValues(alpha: 0.1)
                                  : AppTheme.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _scoreDiff > 0
                                      ? Icons.trending_up_rounded
                                      : Icons.trending_down_rounded,
                                  size: 16,
                                  color: _scoreDiff > 0
                                      ? AppTheme.success
                                      : AppTheme.error,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_scoreDiff > 0 ? '+' : ''}$_scoreDiff',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _scoreDiff > 0
                                        ? AppTheme.success
                                        : AppTheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (widget.message != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.message!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 점수 구성 요소
          _buildScoreBreakdown(),
        ],
      ),
    );
  }

  Widget _buildScoreBreakdown() {
    final items = [
      _ScoreItem('증상 빈도', 85, AppTheme.symptomColor),
      _ScoreItem('식습관', 70, AppTheme.mealColor),
      _ScoreItem('약물 복용', 90, AppTheme.medicationColor),
      _ScoreItem('생활습관', 65, AppTheme.lifestyleColor),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        children: items.map((item) {
          return Expanded(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        value: item.value / 100,
                        strokeWidth: 4,
                        backgroundColor: item.color.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation(item.color),
                      ),
                    ),
                    Text(
                      '${item.value}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: item.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ScoreItem {
  final String label;
  final int value;
  final Color color;

  _ScoreItem(this.label, this.value, this.color);
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
