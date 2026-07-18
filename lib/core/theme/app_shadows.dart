import 'package:flutter/material.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';

class AppShadows {
  const AppShadows._();

  static BoxShadow shadow1 = const BoxShadow(
    color: AppColors.grey100,
    spreadRadius: 1,
    blurRadius: 10,
    offset: Offset(0, 5),
  );
}
