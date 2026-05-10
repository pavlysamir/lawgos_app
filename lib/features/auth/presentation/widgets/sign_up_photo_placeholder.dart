import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';

class SignUpPhotoPlaceholder extends StatelessWidget {
  const SignUpPhotoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          painter: _DashedBorderPainter(),
          child: SizedBox(
            width: 94.w,
            height: 94.w,
            child: Icon(
              Icons.add_a_photo_outlined,
              color: AppColors.primaryColor100,
              size: 30.sp,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'صورتك الشخصية',
          style: AppTextStyles.body3Regular.copyWith(
            color: AppColors.primaryColor100,
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor100.withValues(alpha: 0.45)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final radius = Radius.circular(10.r);
    final rect = RRect.fromRectAndRadius(Offset.zero & size, radius);
    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + 8);
        canvas.drawPath(segment, paint);
        distance += 14;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
