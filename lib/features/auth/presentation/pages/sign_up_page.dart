import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lowgos_app/core/helpers/validation_handling.dart';
import 'package:lowgos_app/core/routing/routes.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lowgos_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/auth_divider.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/auth_google_button.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/sign_up_photo_placeholder.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: _authListener,
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return AuthPageShell(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'إنشاء حساب جديد',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h4Bold.copyWith(
                    color: const Color(0xFF1F55D9),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'ابدأ رحلتك المهنية في عالم القانون اليوم',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body3Regular.copyWith(
                    color: const Color(0xFF7FA3DF),
                  ),
                ),
                SizedBox(height: 20.h),
                const SignUpPhotoPlaceholder(),
                SizedBox(height: 15.h),
                AuthTextField(
                  controller: _nameController,
                  label: 'الأسم',
                  hintText: 'أدخل الأسم ثلاثي',
                  keyboardType: TextInputType.name,
                  validator: conditionOfValidationName,
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 12.h),
                AuthTextField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                  hintText: 'example@law.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationHandling.validateEmail,
                  icon: Icons.mail_outline,
                ),
                SizedBox(height: 12.h),
                AuthTextField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  hintText: '••••••••',
                  keyboardType: TextInputType.visiblePassword,
                  validator: ValidationHandling.validatePassword,
                  showEyeIcon: true,
                  icon: Icons.lock_outline,
                ),
                SizedBox(height: 12.h),
                AuthTextField(
                  controller: _confirmPasswordController,
                  label: 'تأكيد كلمة المرور',
                  hintText: '••••••••',
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) =>
                      ValidationHandling.validateConfirmPassword(
                        value,
                        _passwordController.text,
                      ),
                  showEyeIcon: true,
                  icon: Icons.lock_outline,
                ),
                SizedBox(height: 33.h),
                AuthPrimaryButton(
                  text: 'إنشاء حساب جديد',
                  isLoading: isLoading,
                  onPressed: _submitSignUp,
                ),
                SizedBox(height: 31.h),
                const AuthDivider(),
                SizedBox(height: 25.h),
                Center(
                  child: AuthGoogleButton(
                    isLoading: isLoading,
                    onPressed: context.read<AuthCubit>().signInWithGoogle,
                  ),
                ),
                SizedBox(height: 30.h),
                _AuthFooter(
                  hint: 'لديك حساب؟',
                  action: 'تسجيل الدخول',
                  onTap: () => context.go(Routes.login),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitSignUp() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().signUpWithEmail(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.failure.message)));
    }
    if (state is AuthSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب بنجاح')));
      context.go(Routes.home);
    }
  }
}

class _AuthFooter extends StatelessWidget {
  const _AuthFooter({
    required this.hint,
    required this.action,
    required this.onTap,
  });

  final String hint;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          hint,
          style: AppTextStyles.body3Regular.copyWith(color: AppColors.grey200),
        ),
        SizedBox(width: 4.w),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: AppTextStyles.body3Medium.copyWith(
              color: AppColors.primary500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
