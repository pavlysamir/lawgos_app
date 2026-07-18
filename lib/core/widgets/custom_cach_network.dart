import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/core/widgets/custom_image.dart';

class CustomCachNetwork extends StatelessWidget {
  const CustomCachNetwork({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
  });
  final String url;
  final double height;
  final double width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      errorWidget: (context, url, error) {
        return Container(
          height: height.h,
          color: AppColors.white,
          child: CustomImage(path: AssetsData.logoName, hight: height.h),
        );
      },
      placeholder: (context, url) {
        return SizedBox(
          height: height.sh,
          width: width.sw,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      },
      imageUrl: "https://storage.googleapis.com/moca-live-storage/$url",
      height: height.sh,
      width: width.sw,
      fit: fit,
    );
  }
}
