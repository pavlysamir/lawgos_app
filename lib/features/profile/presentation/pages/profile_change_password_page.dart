import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/helpers/validation_handling.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:lowgos_app/features/profile/domain/entities/profile_data.dart';
import 'package:lowgos_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:lowgos_app/features/profile/presentation/cubit/profile_state.dart';

class ProfileChangePasswordPage extends StatefulWidget {
  const ProfileChangePasswordPage({super.key, required this.data});

  final ProfileData data;

  @override
  State<ProfileChangePasswordPage> createState() =>
      _ProfileChangePasswordPageState();
}

class _ProfileChangePasswordPageState extends State<ProfileChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.data.email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.message)));
        }

        if (state is ProfilePasswordResetEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('راجع بريدك الإلكتروني')),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileActionLoading;

        return Scaffold(
          backgroundColor: AppColors.white,
          body: Stack(
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
                            AppColors.black.withValues(alpha: .05),
                            AppColors.black.withValues(alpha: .18),
                            AppColors.black.withValues(alpha: .36),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 16.w, top: 16.h),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryColor,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 475.h,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(40.w, 48.h, 40.w, 40.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22.r),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'تغيير كلمة المرور',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h4Bold.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        AuthTextField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني',
                          hintText: 'example@law.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: ValidationHandling.validateEmail,
                          icon: Icons.mail_outline,
                        ),
                        const Spacer(),
                        AuthPrimaryButton(
                          text: 'إرسال رابط التغيير',
                          isLoading: isLoading,
                          onPressed: _submit,
                        ),
                        SizedBox(height: 70.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileCubit>().sendPasswordResetEmail(_emailController.text);
  }
}
