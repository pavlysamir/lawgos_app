import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/core/widgets/custom_image.dart';
import 'package:lowgos_app/features/home/domain/entities/home_user.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.user});

  final HomeUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.w, 42.h, 22.w, 22.h),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              HomeProfileImage(imageUrl: user.profileImage),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اهلا بك',
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.navyBlue300,
                    ),
                  ),
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body1SemiBold.copyWith(
                      color: AppColors.navyBlue500,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.w),

              CustomImage(path: AssetsData.cupIcon, hight: 28.h),
            ],
          ),

          SizedBox(height: 12.h),
          Divider(color: AppColors.white50, height: 1.h),
        ],
      ),
    );
  }
}

class HomeProfileImage extends StatelessWidget {
  const HomeProfileImage({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return ClipOval(
      child: Container(
        width: 54.w,
        height: 54.w,
        color: AppColors.grey100,
        child: hasImage
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => const Icon(Icons.person),
              )
            : const Icon(Icons.person, color: AppColors.primaryColor),
      ),
    );
  }
}
