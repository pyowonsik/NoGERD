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
}
