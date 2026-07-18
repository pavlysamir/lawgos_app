import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/widgets/custom_svgImage.dart';

class CustomButtonSmall extends StatelessWidget {
  const CustomButtonSmall({
    super.key,
    required this.function,
    required this.text,
    required this.color,
    this.textColortcolor = Colors.white,
    this.width = 78,
    this.hight = 4,
    required this.borderColor,
    this.textStyle,
    this.imagePath,
    this.iconColor,
  });
  final Function()? function;
  final String text;
  final String? imagePath;

  final Color color;
  final Color? iconColor;

  final Color textColortcolor;
  final double width;
  final double hight;

  final Color borderColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // 👈 دي المهمة
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Container(
        height: hight.h,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1.2),
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imagePath != null
                ? CustomSvgimage(
                    hight: 20.h,
                    path: imagePath ?? '',
                    color: iconColor,
                  )
                : const SizedBox.shrink(),
            Text(
              text,
              style:
                  textStyle ??
                  AppTextStyles.body2Medium.copyWith(color: textColortcolor),
            ),
          ],
        ),
      ),
    );
  }
}
