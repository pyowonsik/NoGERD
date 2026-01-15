import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>()
        ..add(const SettingsEvent.loadSettings()),
      child: const _SettingsPageContent(),
    );
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
              (msg) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg)),
                );
              },
            );
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              const SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  '설정',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
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

                          // 알림 설정
                          _buildSectionTitle('알림 설정'),
                          const SizedBox(height: 12),
                          _buildNotificationSettings(context, state),

                          const SizedBox(height: 24),

                          // 앱 설정
                          _buildSectionTitle('앱 설정'),
                          const SizedBox(height: 12),
                          _buildAppSettings(context, state),

                          const SizedBox(height: 24),

                          // 데이터 관리
                          _buildSectionTitle('데이터 관리'),
                          const SizedBox(height: 12),
                          _buildDataSettings(context, state),

                          const SizedBox(height: 24),

                          // 건강 정보
                          _buildSectionTitle('건강 정보'),
                          const SizedBox(height: 12),
                          _buildHealthInfo(context),

                          const SizedBox(height: 24),

                          // 앱 정보
                          _buildSectionTitle('정보'),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
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
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '로그인 필요',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '로그인하여 데이터를 동기화하세요',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
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

  Widget _buildNotificationSettings(BuildContext context, SettingsState state) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SettingTile(
            icon: Icons.notifications_active_rounded,
            iconColor: AppTheme.warning,
            title: '일일 기록 알림',
            subtitle: '매일 지정된 시간에 알림',
            trailing: Switch(
              value: state.settings.dailyReminderEnabled,
              onChanged: (v) => context
                  .read<SettingsBloc>()
                  .add(SettingsEvent.updateDailyReminder(v)),
              activeColor: AppTheme.primary,
            ),
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.access_time_rounded,
            iconColor: AppTheme.info,
            title: '알림 시간',
            subtitle: state.settings.reminderTime.format(context),
            onTap: () async {
              final time = await CustomTimePicker.show(
                context: context,
                initialTime: state.settings.reminderTime,
                title: '알림 시간',
                subtitle: '일일 기록 알림 시간을 설정하세요',
              );
              if (time != null && context.mounted) {
                context
                    .read<SettingsBloc>()
                    .add(SettingsEvent.updateReminderTime(time));
              }
            },
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.medication_rounded,
            iconColor: AppTheme.medicationColor,
            title: '약 복용 알림',
            subtitle: '복용 시간에 알림',
            trailing: Switch(
              value: state.settings.medicationReminderEnabled,
              onChanged: (v) => context
                  .read<SettingsBloc>()
                  .add(SettingsEvent.updateMedicationReminder(v)),
              activeColor: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings(BuildContext context, SettingsState state) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SettingTile(
            icon: Icons.dark_mode_rounded,
            iconColor: AppTheme.lifestyleColor,
            title: '다크 모드',
            subtitle: '어두운 테마 사용',
            trailing: Switch(
              value: state.settings.darkModeEnabled,
              onChanged: (v) => context
                  .read<SettingsBloc>()
                  .add(SettingsEvent.updateDarkMode(v)),
              activeColor: AppTheme.primary,
            ),
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.language_rounded,
            iconColor: AppTheme.info,
            title: '언어',
            subtitle: '한국어',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDataSettings(BuildContext context, SettingsState state) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SettingTile(
            icon: Icons.cloud_upload_rounded,
            iconColor: AppTheme.success,
            title: '데이터 백업',
            subtitle: '클라우드에 데이터 저장',
            onTap: () {
              _showBackupDialog(context);
            },
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.file_download_rounded,
            iconColor: AppTheme.info,
            title: '데이터 내보내기',
            subtitle: 'CSV 파일로 내보내기',
            onTap: () {
              context.read<SettingsBloc>().add(
                    const SettingsEvent.exportData(),
                  );
            },
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.delete_outline_rounded,
            iconColor: AppTheme.error,
            title: '데이터 삭제',
            subtitle: '모든 기록 삭제',
            onTap: () {
              _showDeleteConfirmDialog(context);
            },
          ),
        ],
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
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: AppTheme.textSecondary,
            title: '개인정보 처리방침',
            subtitle: '',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          SettingTile(
            icon: Icons.mail_outline_rounded,
            iconColor: AppTheme.primary,
            title: '문의하기',
            subtitle: 'pyowonsik@gmail.com',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('데이터 백업'),
        content: const Text('데이터를 클라우드에 백업하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SettingsBloc>().add(
                    const SettingsEvent.backupData(),
                  );
            },
            child: const Text('백업'),
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
}
