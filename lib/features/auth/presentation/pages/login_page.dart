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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  'تسجيل الدخول',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h3Bold.copyWith(color: AppColors.blue),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Lawgooأهلاً بك مجدداً في',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body3Regular.copyWith(
                    color: AppColors.onboarding3Background,
                  ),
                ),
                SizedBox(height: 26.h),
                AuthTextField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                  hintText: 'example@law.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationHandling.validateEmail,
                  icon: Icons.mail_outline,
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'نسيت كلمة المرور؟',
                    style: AppTextStyles.body4Regular.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                ),
                AuthTextField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  hintText: '••••••••',
                  keyboardType: TextInputType.visiblePassword,
                  validator: ValidationHandling.validatePassword,
                  showEyeIcon: true,
                  icon: Icons.lock_outline,
                ),
                SizedBox(height: 34.h),
                AuthPrimaryButton(
                  text: 'تسجيل الدخول',
                  isLoading: isLoading,
                  onPressed: _submitLogin,
                ),
                SizedBox(height: 32.h),
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
                  hint: 'ليس لديك حساب؟',
                  action: 'أنشئ حساباً جديداً الآن',
                  onTap: () => context.go(Routes.signUp),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().loginWithEmail(
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
      ).showSnackBar(const SnackBar(content: Text('تم تسجيل الدخول بنجاح')));
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
