import 'package:flutter/material.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';

class CustomTextRich extends StatelessWidget {
  const CustomTextRich({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onSecondTextTap,
    this.onSecondText = AppColors.primaryColor,
    this.onfirstColorText = Colors.black,
  });

  final String firstText;
  final String secondText;
  final VoidCallback? onSecondTextTap;
  final Color onSecondText;
  final Color onfirstColorText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firstText,
          style: AppTextStyles.body1Medium.copyWith(color: onfirstColorText),
        ),
        TextButton(
          onPressed: onSecondTextTap,
          child: Text(
            secondText,
            style: AppTextStyles.body2Medium.copyWith(
              decoration: TextDecoration.underline,
              decorationThickness: 1.5,
              color: onSecondText,
              decorationColor: onSecondText,
            ),
          ),
        ),
      ],
    );
  }
}
