import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';

class ExamFlowScaffold extends StatelessWidget {
  const ExamFlowScaffold({
    super.key,
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 28.h),
            child: child,
          ),
        ),
      ),
    );
  }
}

class ExamBackButton extends StatelessWidget {
  const ExamBackButton({super.key, this.color = AppColors.white});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).maybePop(),
      icon: RotatedBox(
        quarterTurns: 2,
        child: Icon(Icons.arrow_back, color: color, size: 22.sp),
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(Size(34.w, 34.w)),
    );
  }
}

class ExamPrimaryButton extends StatelessWidget {
  const ExamPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.gold400,
    this.foregroundColor = AppColors.primaryColor,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46.h,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foregroundColor,
                ),
              )
            : Icon(Icons.arrow_back, color: foregroundColor, size: 22.sp),
        label: Text(
          label,
          style: AppTextStyles.body1SemiBold.copyWith(color: foregroundColor),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          disabledBackgroundColor: backgroundColor.withValues(alpha: .7),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
      ),
    );
  }
}
