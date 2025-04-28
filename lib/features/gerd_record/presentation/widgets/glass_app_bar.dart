import 'dart:ui';

import 'package:flutter/material.dart';

class GlassAppBar extends StatelessWidget {
  const GlassAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 60,
          color: Colors.white.withOpacity(0.7),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // 마스코트 로고
              Image.asset(
                'assets/icon.png',
                width: 25,
                height: 25,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF66BB6A)],
                ).createShader(bounds),
                child: const Text(
                  '꾸르꾸웍',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 마스코트 로고 위젯 (작은 크기로 최적화)
  Widget _buildMascotLogo() {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 얼굴
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF66BB6A).withOpacity(0.9),
            ),
          ),

          // 눈
          Positioned(
            top: 9,
            left: 7,
            child: Container(
              width: 3,
              height: 4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 1.5,
                    height: 1.5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 9,
            right: 7,
            child: Container(
              width: 3,
              height: 4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 1.5,
                    height: 1.5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 입
          Positioned(
            bottom: 8,
            child: Container(
              width: 8,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),

          // 볼
          Positioned(
            bottom: 10,
            left: 5,
            child: Container(
              width: 2.5,
              height: 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink.withOpacity(0.4),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 5,
            child: Container(
              width: 2.5,
              height: 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink.withOpacity(0.4),
              ),
            ),
          ),

          // 귀
          Positioned(
            top: 2,
            left: 6,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 5,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xFF66BB6A),
                ),
              ),
            ),
          ),
          Positioned(
            top: 2,
            right: 6,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                width: 5,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xFF66BB6A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
