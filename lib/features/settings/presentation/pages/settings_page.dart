import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'package:no_gerd/core/di/injection.dart';
import 'package:no_gerd/features/auth/domain/entities/user.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_event.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_state.dart';
import 'package:no_gerd/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:no_gerd/features/settings/presentation/widgets/setting_tile.dart';
import 'package:no_gerd/shared/shared.dart';

/// 설정 페이지 (BLoC 통합)
class SettingsPage extends StatelessWidget {
  /// 생성자
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // SettingsBloc은 이미 app.dart에서 전역으로 제공됨
    return const _SettingsPageContent();
  }
}

class _SettingsPageContent extends StatelessWidget {
  const _SettingsPageContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: BlocListener<SettingsBloc, SettingsState>(
          listenWhen: (prev, curr) => prev.message != curr.message,
          listener: (context, state) {
            state.message.fold(
              () => null,
              (msg) async {
                // 데이터 내보내기 성공 시 공유 다이얼로그 표시
                if (msg.contains('내보냈습니다')) {
                  final filePath = msg.split(': ').last;
                  final file = File(filePath);

                  if (await file.exists()) {
                    // 공유 다이얼로그 표시
                    final result = await Share.shareXFiles(
                      [XFile(filePath)],
                      subject: 'NoGERD 데이터 백업',
                      text: 'NoGERD 앱의 건강 기록 데이터입니다.',
                    );

                    // 공유 성공 메시지
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result.status == ShareResultStatus.success
                                ? '파일을 공유했습니다'
                                : result.status == ShareResultStatus.dismissed
                                    ? '공유를 취소했습니다'
                                    : '데이터 내보내기 완료',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                } else {
                  // 다른 메시지는 기존대로 스낵바 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(msg),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
            );
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  '설정',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                centerTitle: true,
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<SettingsBloc, SettingsState>(
                    buildWhen: (previous, current) =>
                        previous.isLoading != current.isLoading ||
                        previous.settings != current.settings ||
                        previous.isProcessing != current.isProcessing,
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 프로필 섹션
                          _buildProfileSection(context),

                          const SizedBox(height: 24),

                          // 데이터 관리
                          _buildSectionTitle('데이터 관리', context),
                          const SizedBox(height: 12),
                          _buildDataSettings(context, state),

                          const SizedBox(height: 24),

                          // 건강 정보
                          _buildSectionTitle('건강 정보', context),
                          const SizedBox(height: 12),
                          _buildHealthInfo(context),

                          const SizedBox(height: 24),

                          // 앱 정보
                          _buildSectionTitle('정보', context),
                          const SizedBox(height: 12),
                          _buildAppInfo(context),

                          const SizedBox(height: 100),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return authState.maybeWhen(
          authenticated: (User user) => GlassCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.email.split('@').first,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GradientButton(
                  text: '로그아웃',
                  icon: Icons.logout_rounded,
                  onPressed: () => _handleLogout(context),
                ),
              ],
            ),
          ),
          orElse: () => GlassCard(
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '로그인 필요',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '로그인하여 데이터를 동기화하세요',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('로그아웃'),
        content: const Text('로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(const AuthEvent.signOut());
              // GoRouter의 redirect가 자동으로 로그인 페이지로 이동
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSettings(BuildContext context, SettingsState state) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: SettingTile(
        icon: Icons.delete_outline_rounded,
        iconColor: AppTheme.error,
        title: '데이터 삭제',
        subtitle: '모든 기록 삭제',
        onTap: state.isProcessing
            ? null
            : () {
                _showDeleteConfirmDialog(context);
              },
      ),
    );
  }

  Widget _buildHealthInfo(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SettingTile(
            icon: Icons.local_hospital_rounded,
            iconColor: AppTheme.symptomColor,
            title: '역류성 식도염이란?',
            subtitle: '질환에 대해 알아보기',
            onTap: () {
              _showHealthInfoDialog(context);
            },
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.food_bank_rounded,
            iconColor: AppTheme.mealColor,
            title: '피해야 할 음식',
            subtitle: '트리거 음식 목록',
            onTap: () {
              _showTriggerFoodsDialog(context);
            },
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.tips_and_updates_rounded,
            iconColor: AppTheme.warning,
            title: '생활 수칙',
            subtitle: '일상 관리 가이드',
            onTap: () {
              _showLifestyleTipsDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SettingTile(
            icon: Icons.info_outline_rounded,
            iconColor: AppTheme.textSecondary,
            title: '앱 버전',
            subtitle: '2.0.0',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.description_outlined,
            iconColor: AppTheme.textSecondary,
            title: '이용약관',
            subtitle: '',
            onTap: () => _showTermsOfServiceDialog(context),
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: AppTheme.textSecondary,
            title: '개인정보 처리방침',
            subtitle: '',
            onTap: () => _showPrivacyPolicyDialog(context),
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.mail_outline_rounded,
            iconColor: AppTheme.primary,
            title: '문의하기',
            subtitle: 'qqrtyu@gmail.com',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('데이터 삭제'),
        content: const Text('모든 기록이 삭제됩니다. 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SettingsBloc>().add(
                    const SettingsEvent.deleteAllData(),
                  );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _showHealthInfoDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '🏥 역류성 식도염이란?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '역류성 식도염(GERD)은 위산이나 위 내용물이 식도로 역류하여 불편한 증상을 유발하거나 식도 점막에 손상을 일으키는 질환입니다.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoSection('주요 증상', [
                  '• 가슴쓰림 (타는 듯한 느낌)',
                  '• 산 역류 (신맛이 올라옴)',
                  '• 만성 기침',
                  '• 목 이물감',
                  '• 쉰 목소리',
                  '• 연하곤란 (삼키기 어려움)',
                ]),
                const SizedBox(height: 20),
                _buildInfoSection('주요 원인', [
                  '• 하부식도괄약근 기능 저하',
                  '• 비만',
                  '• 임신',
                  '• 흡연',
                  '• 특정 음식 및 음료',
                  '• 스트레스',
                ]),
                const SizedBox(height: 20),
                _buildInfoSection('치료 방법', [
                  '• 생활습관 개선',
                  '• 약물치료 (PPI, H2 차단제)',
                  '• 식이요법',
                  '• 심한 경우 수술적 치료',
                ]),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTriggerFoodsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '⚠️ 피해야 할 음식',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFoodCategory('🍟 기름진 음식', '튀김, 패스트푸드, 삼겹살'),
                _buildFoodCategory('🌶️ 매운 음식', '고추, 마라, 매운 찌개'),
                _buildFoodCategory('☕ 카페인', '커피, 에너지드링크, 녹차'),
                _buildFoodCategory('🥤 탄산음료', '콜라, 사이다, 탄산수'),
                _buildFoodCategory('🍺 술', '맥주, 소주, 와인'),
                _buildFoodCategory('🍋 산성 과일', '오렌지, 레몬, 토마토'),
                _buildFoodCategory('🍫 초콜릿', '초콜릿, 코코아'),
                _buildFoodCategory('🌿 민트', '페퍼민트, 민트차'),
                const SizedBox(height: 20),
                const Text(
                  '✅ 권장 음식',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFoodCategory('🍌 바나나', '위산을 중화하는 데 도움'),
                _buildFoodCategory('🥬 채소', '식이섬유가 풍부'),
                _buildFoodCategory('🍚 통곡물', '현미, 귀리'),
                _buildFoodCategory('🍗 저지방 단백질', '닭가슴살, 생선'),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLifestyleTipsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '💡 생활 수칙',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTipItem('🍽️', '식사 후 2-3시간은 눕지 마세요'),
                _buildTipItem('🛏️', '침대 머리를 15-20cm 높이세요'),
                _buildTipItem('👔', '꽉 끼는 옷을 피하세요'),
                _buildTipItem('🍴', '소량씩 자주 식사하세요'),
                _buildTipItem('🚭', '금연하세요'),
                _buildTipItem('⚖️', '적정 체중을 유지하세요'),
                _buildTipItem('🧘', '스트레스를 관리하세요'),
                _buildTipItem('🚶', '식후 가벼운 산책을 하세요'),
                _buildTipItem('🌙', '야식을 피하세요'),
                _buildTipItem('💧', '물을 자주 마시세요'),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodCategory(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            title.split(' ').first,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.split(' ').skip(1).join(' '),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String emoji, String tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsOfServiceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 헤더
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '이용약관',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // 내용
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermsSection(
                        '제1조 (목적)',
                        '본 약관은 NoGERD(이하 "서비스")의 이용과 관련하여 서비스 제공자와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.',
                      ),
                      _buildTermsSection(
                        '제2조 (정의)',
                        '1. "서비스"란 역류성 식도염 관리를 위한 건강 기록 애플리케이션을 의미합니다.\n'
                            '2. "이용자"란 본 약관에 따라 서비스를 이용하는 회원을 말합니다.\n'
                            '3. "건강 정보"란 이용자가 서비스에 입력하는 증상, 식사, 약물, 생활습관 등의 정보를 말합니다.',
                      ),
                      _buildTermsSection(
                        '제3조 (약관의 효력 및 변경)',
                        '1. 본 약관은 서비스 화면에 게시하거나 기타의 방법으로 이용자에게 공지함으로써 효력이 발생합니다.\n'
                            '2. 회사는 필요한 경우 관련 법령을 위배하지 않는 범위에서 본 약관을 변경할 수 있습니다.\n'
                            '3. 약관이 변경되는 경우, 회사는 변경사항을 시행일자 7일 전부터 공지합니다.',
                      ),
                      _buildTermsSection(
                        '제4조 (서비스의 제공)',
                        '1. 회사는 다음과 같은 서비스를 제공합니다:\n'
                            '   - 건강 기록 입력 및 관리\n'
                            '   - 증상 추이 분석\n'
                            '   - 식습관 및 생활습관 관리\n'
                            '   - 알림 기능\n'
                            '2. 서비스는 연중무휴 1일 24시간 제공함을 원칙으로 합니다.\n'
                            '3. 회사는 서비스 개선을 위해 정기점검을 실시할 수 있으며, 사전에 공지합니다.',
                      ),
                      _buildTermsSection(
                        '제5조 (이용자의 의무)',
                        '1. 이용자는 정확한 건강 정보를 입력하여야 합니다.\n'
                            '2. 이용자는 타인의 개인정보를 도용하거나 부정하게 사용할 수 없습니다.\n'
                            '3. 이용자는 관련 법령, 본 약관의 규정, 이용안내 및 서비스상에 공지한 주의사항을 준수하여야 합니다.',
                      ),
                      _buildTermsSection(
                        '제6조 (의료 행위 제한)',
                        '본 서비스는 건강 기록 관리 도구로서, 의료 진단이나 치료를 목적으로 하지 않습니다. 질병의 진단, 치료, 예방 등의 의료 행위는 반드시 의료 전문가와 상담하시기 바랍니다.',
                      ),
                      _buildTermsSection(
                        '제7조 (책임의 제한)',
                        '1. 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.\n'
                            '2. 회사는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여 책임을 지지 않습니다.\n'
                            '3. 회사는 이용자가 서비스를 이용하여 기대하는 건강 개선 효과 등에 대하여 책임을 지지 않습니다.',
                      ),
                      _buildTermsSection(
                        '제8조 (분쟁 해결)',
                        '1. 회사와 이용자는 서비스와 관련하여 발생한 분쟁을 원만하게 해결하기 위하여 필요한 모든 노력을 하여야 합니다.\n'
                            '2. 제1항의 규정에도 불구하고, 분쟁이 해결되지 않을 경우 관할법원은 민사소송법상의 관할법원으로 합니다.',
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '시행일: 2026년 1월 16일',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 헤더
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '개인정보 처리방침',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // 내용
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermsSection(
                        '1. 개인정보의 수집 및 이용 목적',
                        'NoGERD는 다음의 목적을 위하여 개인정보를 처리합니다:\n'
                            '• 회원 가입 및 관리\n'
                            '• 건강 기록 서비스 제공\n'
                            '• 서비스 개선 및 분석\n'
                            '• 알림 서비스 제공',
                      ),
                      _buildTermsSection(
                        '2. 수집하는 개인정보의 항목',
                        '가. 필수 수집 항목\n'
                            '• 이메일 주소\n'
                            '• 비밀번호 (암호화 저장)\n\n'
                            '나. 자동 수집 항목\n'
                            '• 서비스 이용 기록\n'
                            '• 접속 로그\n'
                            '• 기기 정보\n\n'
                            '다. 건강 정보\n'
                            '• 증상 기록 (증상 종류, 심각도, 발생 시간)\n'
                            '• 식사 기록 (식사 유형, 음식 종류, 포만감)\n'
                            '• 약물 기록 (약물 종류, 복용 시간)\n'
                            '• 생활습관 기록 (수면, 운동, 스트레스 등)',
                      ),
                      _buildTermsSection(
                        '3. 개인정보의 보유 및 이용 기간',
                        '• 회원 탈퇴 시까지 보유\n'
                            '• 단, 관계 법령에 의해 보존할 필요가 있는 경우 해당 기간 동안 보유\n'
                            '• 회원이 직접 입력한 건강 기록은 회원이 삭제하기 전까지 보관',
                      ),
                      _buildTermsSection(
                        '4. 개인정보의 제3자 제공',
                        'NoGERD는 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다. 다만, 다음의 경우에는 예외로 합니다:\n'
                            '• 이용자가 사전에 동의한 경우\n'
                            '• 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우',
                      ),
                      _buildTermsSection(
                        '5. 개인정보의 파기',
                        '• 파기 절차: 회원 탈퇴 시 지체 없이 파기\n'
                            '• 파기 방법: 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제',
                      ),
                      _buildTermsSection(
                        '6. 개인정보의 안전성 확보 조치',
                        'NoGERD는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다:\n'
                            '• 비밀번호 암호화: 비밀번호는 암호화되어 저장 및 관리\n'
                            '• 해킹 등에 대비한 기술적 대책\n'
                            '• 접근 제한: 개인정보를 처리하는 데이터베이스 시스템에 대한 접근 권한 부여, 변경, 말소\n'
                            '• 접속 기록 보관: 개인정보처리시스템에 대한 접속 기록을 최소 6개월 이상 보관',
                      ),
                      _buildTermsSection(
                        '7. 민감정보의 처리',
                        '본 서비스는 건강 관련 민감정보를 수집합니다. 이는 서비스 제공을 위한 필수적인 정보이며, 이용자의 동의 없이 제3자에게 제공되지 않습니다.',
                      ),
                      _buildTermsSection(
                        '8. 이용자의 권리',
                        '이용자는 언제든지 다음의 권리를 행사할 수 있습니다:\n'
                            '• 개인정보 열람 요구\n'
                            '• 개인정보 정정·삭제 요구\n'
                            '• 개인정보 처리 정지 요구\n'
                            '• 회원 탈퇴(동의 철회)',
                      ),
                      _buildTermsSection(
                        '9. 개인정보 보호책임자',
                        '성명: NoGERD 개인정보 보호책임자\n'
                            '이메일: qqrtyu@gmail.com\n\n'
                            '개인정보 처리에 관한 문의사항이 있으시면 언제든지 연락 주시기 바랍니다.',
                      ),
                      _buildTermsSection(
                        '10. 개인정보 처리방침의 변경',
                        '본 개인정보 처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경 내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.',
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '시행일: 2026년 1월 16일',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
