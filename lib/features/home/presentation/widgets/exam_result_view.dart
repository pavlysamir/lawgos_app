import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';

class ExamResultView extends StatelessWidget {
  const ExamResultView({
    super.key,
    required this.percentage,
    required this.correctAnswersCount,
    required this.totalQuestionsCount,
    required this.earnedPoints,
    required this.isPassed,
    required this.onPrimaryPressed,
    required this.onBackPressed,
  });

  final int percentage;
  final int correctAnswersCount;
  final int totalQuestionsCount;
  final int earnedPoints;
  final bool isPassed;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final resultColor = isPassed ? AppColors.success700 : AppColors.error100;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(24.w, 34.h, 24.w, 30.h),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFD7E5FF), AppColors.white],
              stops: [.0, .54],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    onPressed: onBackPressed,
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.navyBlue300,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  isPassed ? '👏 أحسنت' : '👍 حاول مرة ثانية',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h3Bold.copyWith(
                    color: AppColors.primaryColor,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 48.h),
                _PercentageRing(
                  percentage: percentage,
                  color: resultColor,
                  isPassed: isPassed,
                  earnedPoints: earnedPoints,
                ),
                const Spacer(),
                Text(
                  isPassed ? 'نجحت في هذا\nالمستوى!' : 'قربت توصل',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h4Bold.copyWith(
                    color: AppColors.primaryColor,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  isPassed
                      ? 'جاوبت بشكل صحيح على عدد كافي\nمن الأسئلة لتجاوز المستوى 🎯\n($correctAnswersCount من $totalQuestionsCount)'
                      : 'أدائك كويس،\nبس محتاج شوية تركيز كمان عشان\nتعدي المستوى',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1Regular.copyWith(
                    color: AppColors.navyBlue300,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 48.h),
                _ResultButton(
                  label: isPassed ? 'المستوى التالي' : 'حاول مرة أخرى',
                  icon: isPassed ? Icons.arrow_back : Icons.refresh,
                  onPressed: onPrimaryPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PercentageRing extends StatelessWidget {
  const _PercentageRing({
    required this.percentage,
    required this.color,
    required this.isPassed,
    required this.earnedPoints,
  });

  final int percentage;
  final Color color;
  final bool isPassed;
  final int earnedPoints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176.w,
      height: isPassed ? 192.h : 176.h,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size.square(160.w),
            painter: _RingPainter(
              progress: percentage / 100,
              color: color,
              showTrack: isPassed,
            ),
          ),
          Text(
            '$percentage%',
            style: AppTextStyles.h3Bold.copyWith(
              color: AppColors.primaryColor,
              fontSize: 34.sp,
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(
                isPassed ? Icons.check : Icons.close,
                color: AppColors.white,
                size: 16.sp,
              ),
            ),
          ),
          if (isPassed)
            Positioned(
              bottom: 14.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.gold50,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_circle, color: AppColors.gold, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '+$earnedPoints نقطة',
                      style: AppTextStyles.body5Regular.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.color,
    required this.showTrack,
  });

  final double progress;
  final Color color;
  final bool showTrack;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 9.w;
    final rect = Offset.zero & size;
    final trackPaint = Paint()
      ..color = AppColors.gold50
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (showTrack) {
      canvas.drawArc(
        rect.deflate(strokeWidth / 2),
        0,
        6.28318,
        false,
        trackPaint,
      );
    }
    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      -1.5708,
      6.28318 * progress.clamp(0, 1),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        showTrack != oldDelegate.showTrack;
  }
}

class _ResultButton extends StatelessWidget {
  const _ResultButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46.h,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.white, size: 22.sp),
        label: Text(
          label,
          style: AppTextStyles.body1SemiBold.copyWith(color: AppColors.white),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 18,
          shadowColor: AppColors.blue.withValues(alpha: .35),
          backgroundColor: const Color(0xFF2454D8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
      ),
    );
  }
}
