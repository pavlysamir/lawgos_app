import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/helpers/validation_handling.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:lowgos_app/features/profile/domain/entities/profile_data.dart';
import 'package:lowgos_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:lowgos_app/features/profile/presentation/cubit/profile_state.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key, required this.data});

  final ProfileData data;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data.userName);
    _emailController = TextEditingController(text: widget.data.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
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

        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تعديل الملف الشخصي بنجاح')),
          );
          Navigator.of(context).pop();
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
                  height: 470.h,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(40.w, 58.h, 40.w, 40.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22.r),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _nameController,
                          label: 'الأسم',
                          hintText: 'أدخل الأسم',
                          keyboardType: TextInputType.name,
                          validator: _validateName,
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 18.h),
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
                          text: 'تعديل',
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

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الأسم مطلوب';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileCubit>().updateProfile(
      name: _nameController.text,
      email: _emailController.text,
    );
  }
}
