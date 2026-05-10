import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:lowgos_app/features/home/presentation/widgets/law_slider_card.dart';

class LawCarouselSection extends StatelessWidget {
  const LawCarouselSection({
    super.key,
    required this.laws,
    required this.selectedIndex,
    required this.isStartingLaw,
  });

  final List<Law> laws;
  final int selectedIndex;
  final bool isStartingLaw;

  // Colors list
  static final List<Color> cardColors = [
    AppColors.blue,
    AppColors.gold,
    AppColors.error700,
    AppColors.success300,
    AppColors.onboarding3Background,
    AppColors.gColor,
  ];

  @override
  Widget build(BuildContext context) {
    if (laws.isEmpty) {
      return SizedBox(
        height: 320.h,
        child: const Center(child: Text('لا توجد قوانين متاحة الآن')),
      );
    }

    return CarouselSlider.builder(
      itemCount: laws.length,

      itemBuilder: (context, index, realIndex) {
        final isSelected = index == selectedIndex;

        // Repeat colors automatically
        final cardColor = cardColors[index % cardColors.length];

        return AnimatedScale(
          duration: const Duration(milliseconds: 220),
          scale: isSelected ? 1 : .88,
          child: LawSliderCard(
            law: laws[index],
            isLoading: isSelected && isStartingLaw,
            onStart: context.read<HomeCubit>().startSelectedLaw,
            color: cardColor,
          ),
        );
      },
      options: CarouselOptions(
        height: 350.h,
        viewportFraction: .7,
        enlargeCenterPage: false,
        enableInfiniteScroll: laws.length > 1,
        onPageChanged: (index, reason) {
          context.read<HomeCubit>().changeLaw(index);
        },
      ),
    );
  }
}
