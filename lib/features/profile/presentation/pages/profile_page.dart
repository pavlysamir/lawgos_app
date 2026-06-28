import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lowgos_app/core/routing/routes.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/features/profile/domain/entities/profile_data.dart';
import 'package:lowgos_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:lowgos_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:lowgos_app/features/profile/presentation/pages/profile_change_password_page.dart';
import 'package:lowgos_app/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:lowgos_app/features/profile/presentation/pages/profile_terms_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? true;
        if (state is ProfileError && isCurrentRoute) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.message)));
        }

        if (state is ProfileLogoutSuccess ||
            state is ProfileDeleteAccountSuccess) {
          context.go(Routes.login);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = _profileDataFromState(state);
        if (data == null) {
          return Center(
            child: TextButton(
              onPressed: context.read<ProfileCubit>().loadProfile,
              child: const Text('إعادة المحاولة'),
            ),
          );
        }

        return _ProfileContent(
          data: data,
          isActionLoading: state is ProfileActionLoading,
        );
      },
    );
  }

  ProfileData? _profileDataFromState(ProfileState state) {
    if (state is ProfileLoaded) return state.data;
    if (state is ProfileActionLoading) return state.data;
    if (state is ProfileError) return state.data;
    if (state is ProfileUpdateSuccess) return state.data;
    if (state is ProfilePasswordResetEmailSent) return state.data;
    return null;
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.data, required this.isActionLoading});

  final ProfileData data;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<ProfileCubit>().loadProfile,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _ProfileHeader(data: data)),
          SliverToBoxAdapter(child: SizedBox(height: 14.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'الإعدادات',
                  style: AppTextStyles.h4Bold.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 8.h)),
          SliverToBoxAdapter(
            child: _SettingsList(isActionLoading: isActionLoading),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 112.h)),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.data});

  final ProfileData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 425.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 356.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AssetsData.profileCoverImg, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.black.withValues(alpha: .06),
                        AppColors.black.withValues(alpha: .28),
                        AppColors.black.withValues(alpha: .54),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            start: 22.w,
            end: 22.w,
            bottom: 76.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ملفك الشخصي',
                  style: AppTextStyles.h5Regular.copyWith(
                    color: AppColors.white.withValues(alpha: .78),
                  ),
                ),
                Text(
                  data.userName.isEmpty ? 'مستخدم' : data.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h3Bold.copyWith(
                    color: AppColors.white,
                    fontSize: 34.sp,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 60.h),
              ],
            ),
          ),
          PositionedDirectional(
            start: 8.w,
            end: 8.w,
            bottom: 0,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.star_border_rounded,
                    iconColor: AppColors.gold,
                    label: 'النقاط الإجمالية',
                    value: data.totalPoints.toString(),
                    footer: 'XP',
                    valueColor: AppColors.gold,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    icon: Icons.question_mark,
                    iconColor: AppColors.blue,
                    iconBackgroundColor: AppColors.primaryColor40.withValues(
                      alpha: .28,
                    ),
                    label: 'عدد الأسئلة',
                    value: data.totalAnsweredQuestions.toString(),
                    footer: 'سؤال تم حله',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    icon: Icons.menu_book_outlined,
                    iconColor: AppColors.primaryColor40,
                    label: 'المستويات المكتملة',
                    value: data.completedLevelsCount.toString(),
                    footer: 'مستوى مكتمل',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.footer,
    this.iconBackgroundColor,
    this.valueColor = AppColors.blue,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String footer;
  final Color? iconBackgroundColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey200.withValues(alpha: .5),
            blurRadius: 16,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? AppColors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 26.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body3SemiBold.copyWith(
              color: AppColors.navyBlue,
              fontSize: 11.sp,
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body1SemiBold.copyWith(color: valueColor),
          ),
          Text(
            footer,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body4Regular.copyWith(
              color: AppColors.navyBlue,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList({required this.isActionLoading});

  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isActionLoading,
      child: Column(
        children: [
          _SettingsItem(
            icon: Icons.person_outline,
            title: 'تعديل الملف الشخصي',
            onTap: () => _openEditProfilePage(context),
          ),
          _SettingsItem(
            icon: Icons.shield_outlined,
            title: 'تغيير كلمة المرور',
            onTap: () => _openChangePasswordPage(context),
          ),
          _SettingsItem(
            icon: Icons.gavel_outlined,
            title: 'الشروط و الأحكام',
            onTap: () => _openTermsPage(context),
          ),
          _SettingsItem(
            icon: Icons.delete_outline,
            title: 'حذف حسابك',
            onTap: () => _showDeleteAccountDialog(context),
          ),
          _SettingsItem(
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            color: AppColors.error100,
            showArrow: false,
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color = AppColors.navyBlue700,
    this.showArrow = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 47.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),

        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: AppColors.primaryColor100,
                size: 22.sp,
              )
            else
              SizedBox(width: 22.w),
            const Spacer(),
            Text(
              title,
              style: AppTextStyles.body2Medium.copyWith(color: color),
            ),
            SizedBox(width: 14.w),
            Icon(icon, color: color, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

void _openTermsPage(BuildContext context) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const ProfileTermsPage()));
}

void _openChangePasswordPage(BuildContext context) {
  final cubit = context.read<ProfileCubit>();
  final data = _profileDataFromCubit(cubit);
  if (data == null) return;

  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ProfileChangePasswordPage(data: data),
      ),
    ),
  );
}

void _openEditProfilePage(BuildContext context) {
  final cubit = context.read<ProfileCubit>();
  final data = _profileDataFromCubit(cubit);
  if (data == null) return;

  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ProfileEditPage(data: data!),
      ),
    ),
  );
}

ProfileData? _profileDataFromCubit(ProfileCubit cubit) {
  final state = cubit.state;

  if (state is ProfileLoaded) return state.data;
  if (state is ProfileUpdateSuccess) return state.data;
  if (state is ProfilePasswordResetEmailSent) return state.data;
  if (state is ProfileActionLoading) return state.data;
  if (state is ProfileError) return state.data;

  return null;
}

Future<void> _showLogoutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return _ProfileConfirmDialog(
        icon: Icons.power_settings_new,
        title: 'تسجيل الخروج',
        message: 'هل أنت متأكد من رغبتك في\nتسجيل الخروج من الابليكشن؟',
        confirmLabel: 'تسجيل الخروج',
        confirmIcon: Icons.logout,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          context.read<ProfileCubit>().logout();
        },
      );
    },
  );
}

Future<void> _showDeleteAccountDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return _ProfileConfirmDialog(
        icon: Icons.delete_outline,
        title: 'هل أنت متأكد من\nحذف حسابك؟',
        confirmLabel: 'تأكيد الحذف',
        confirmIcon: Icons.delete_outline,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          context.read<ProfileCubit>().deleteAccount();
        },
      );
    },
  );
}

class _ProfileConfirmDialog extends StatelessWidget {
  const _ProfileConfirmDialog({
    required this.icon,
    required this.title,
    required this.confirmLabel,
    required this.confirmIcon,
    required this.onConfirm,
    this.message,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String confirmLabel;
  final IconData confirmIcon;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 38.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(32.w, 34.h, 32.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78.w,
              height: 78.w,
              decoration: BoxDecoration(
                color: AppColors.error100.withValues(alpha: .18),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error100.withValues(alpha: .18),
                    blurRadius: 28,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: AppColors.error100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.white, size: 34.sp),
                ),
              ),
            ),
            SizedBox(height: 28.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4Bold.copyWith(
                color: AppColors.navyBlue900,
                height: 1.28,
              ),
            ),
            if (message != null) ...[
              SizedBox(height: 10.h),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body1Regular.copyWith(
                  color: AppColors.navyBlue300,
                  height: 1.35,
                ),
              ),
            ],
            SizedBox(height: 28.h),
            _DialogActionButton(
              label: confirmLabel,
              icon: confirmIcon,
              backgroundColor: AppColors.error100,
              foregroundColor: AppColors.white,
              onPressed: onConfirm,
            ),
            SizedBox(height: 12.h),
            _DialogActionButton(
              label: 'إلغاء',
              backgroundColor: AppColors.navyBlue50,
              foregroundColor: AppColors.primaryColor,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final labelWidget = Text(
      label,
      style: AppTextStyles.body2SemiBold.copyWith(color: foregroundColor),
    );
    final buttonStyle = ElevatedButton.styleFrom(
      elevation: backgroundColor == AppColors.error100 ? 10 : 0,
      shadowColor: AppColors.error100.withValues(alpha: .28),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
    );

    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: icon == null
          ? ElevatedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: labelWidget,
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: foregroundColor, size: 18.sp),
              label: labelWidget,
              style: buttonStyle,
            ),
    );
  }
}
