import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/custom_form_field_no_label.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.keyboardType,
    this.validator,
    this.showEyeIcon = false,
    this.icon,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool showEyeIcon;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 14.w, bottom: 6.h),
          child: Text(
            label,
            style: AppTextStyles.body3Regular.copyWith(
              color: AppColors.navyBlue,
            ),
          ),
        ),
        CustomFormFieldNoLabel(
          controller: controller,
          hintText1: hintText,
          hintText2: '',
          hintTextColor2: AppColors.primaryColor100,
          hintTextColor: AppColors.primaryColor100,
          textInputType: keyboardType,
          validate: validator,
          fillColor: AppColors.grey100,
          borderColor: AppColors.primaryColor100,
          textColor: AppColors.primary500,
          showEyeIcon: showEyeIcon,
          suffixIcon: icon == null
              ? null
              : Icon(icon, color: AppColors.primaryColor100, size: 22.sp),
        ),
      ],
    );
  }
}
