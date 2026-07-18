import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/core/widgets/custom_image.dart';

class LawLevelsAppBar extends StatelessWidget {
  const LawLevelsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22.w, 60.h, 22.w, 0),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: RotatedBox(
              quarterTurns: 2,
              child: Icon(
                Icons.arrow_back,
                color: AppColors.navyBlue500,
                size: 24.sp,
              ),
            ),
          ),
          const Spacer(),
          CustomImage(path: AssetsData.logoImg, hight: 40.h, width: 40.w),
        ],
      ),
    );
  }
}
