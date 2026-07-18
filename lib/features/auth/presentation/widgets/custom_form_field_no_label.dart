import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/theme/font_weight_helper.dart';

class CustomFormFieldNoLabel extends StatefulWidget {
  const CustomFormFieldNoLabel({
    super.key,
    required this.controller,
    this.onChanged,
    required this.hintText1,
    required this.hintText2,
    this.hintTextColor,
    required this.textInputType,
    this.suffixIcon,
    this.prefixIcon,
    this.showEyeIcon = false,
    this.initialValue,
    this.readOnly = false,
    this.validate,
    this.fillColor,
    this.borderColor,
    this.hintTextColor2,
    this.onTapOutside,
    this.stroclWidth = 0,
    this.textColor,
  });

  final TextEditingController controller;
  final String hintText1;
  final String hintText2;
  final Color? hintTextColor;
  final Color? hintTextColor2;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final Color? textColor;
  final String? Function(String?)? validate;
  final void Function(String value)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final bool showEyeIcon;
  final String? initialValue;
  final bool readOnly;
  final double? stroclWidth;

  @override
  State<CustomFormFieldNoLabel> createState() => _CustomFormFieldNoLabelState();
}

class _CustomFormFieldNoLabelState extends State<CustomFormFieldNoLabel> {
  final FocusNode _focusNode = FocusNode();
  bool _showPassword = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: widget.borderColor ?? AppColors.primary500,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      initialValue: widget.initialValue,
      style: AppTextStyles.body3Medium.copyWith(
        color: widget.textColor ?? AppColors.primary500,
      ),
      obscureText: widget.showEyeIcon ? _showPassword : false,
      keyboardType: widget.textInputType,
      controller: widget.controller,
      validator: widget.validate,
      textAlign: TextAlign.right,
      onTapOutside:
          widget.onTapOutside ??
          (event) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 13.h),
        filled: widget.fillColor != null,
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.showEyeIcon ? _buildEyeIcon() : widget.prefixIcon,
        fillColor: widget.fillColor,
        enabledBorder: outlineInputBorder(
          context,
          widget.stroclWidth ?? 0,
          color: widget.borderColor,
        ),
        focusedBorder: outlineInputBorder(
          context,
          1.2,
          color: widget.borderColor ?? AppColors.primary500,
        ),
        errorBorder: outlineInputBorderError(1, color: AppColors.error300),
        focusedErrorBorder: outlineInputBorderError(
          1.2,
          color: AppColors.error600,
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 46.w, minHeight: 20.h),
        suffixIconConstraints: BoxConstraints(minWidth: 46.w, minHeight: 20.h),
        hint: RichText(
          textAlign: TextAlign.right,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.hintText1,
                style: AppTextStyles.body3Regular.copyWith(
                  color: widget.hintTextColor2 ?? AppColors.grey300,
                ),
              ),
              TextSpan(
                text: widget.hintText2,
                style: AppTextStyles.body3Regular.copyWith(
                  color: widget.hintTextColor ?? AppColors.grey300,
                  fontWeight: FontWeightHelper.semiBold,
                ),
              ),
            ],
          ),
        ),
        errorStyle: AppTextStyles.body4Regular.copyWith(
          color: AppColors.error600,
        ),
      ),
    );
  }

  Widget _buildEyeIcon() {
    return IconButton(
      onPressed: () => setState(() => _showPassword = !_showPassword),
      icon: Icon(
        _showPassword ? Icons.visibility_off_outlined : Icons.visibility,
        color: widget.borderColor ?? AppColors.primaryColor100,
        size: 22.sp,
      ),
    );
  }
}

InputBorder outlineInputBorder(
  BuildContext context,
  double stroclWidth, {
  Color? color,
}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: color ?? AppColors.transparent,
      width: stroclWidth,
    ),
    borderRadius: BorderRadius.circular(30.r),
  );
}

OutlineInputBorder outlineInputBorderError(double stroclWidth, {Color? color}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: color ?? AppColors.error300,
      width: stroclWidth,
    ),
    borderRadius: BorderRadius.circular(30.r),
  );
}
