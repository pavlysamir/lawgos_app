import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lowgos_app/core/di/injection.dart';
import 'package:lowgos_app/core/routing/routes.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:lowgos_app/features/on_boarding/presentation/cubit/on_boarding_state.dart';
import 'package:lowgos_app/features/on_boarding/presentation/widgets/custom_indicator.dart';
import 'package:lowgos_app/features/on_boarding/presentation/widgets/on_boarding_first_item.dart';
import 'package:lowgos_app/features/on_boarding/presentation/widgets/on_boarding_second_item.dart';
import 'package:lowgos_app/features/on_boarding/presentation/widgets/on_boarding_third_item.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const OnBoardingFirstItem(),
      const OnBoardingSecondItem(),
      const OnBoardingThirdItem(),
    ];

    final List<Color> backgroundColors = [
      AppColors.onboarding1GoldBackground,

      AppColors.primary500,
      AppColors.onboarding3Background,
    ];

    final PageController controller = PageController();

    return BlocProvider(
      create: (context) => getIt<OnBoardingCubit>(),
      child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {
          if (state is OnBoardingCompleted) {
            context.go(Routes.login);
          }
        },
        builder: (context, state) {
          int currentIndex = 0;
          if (state is OnBoardingPageChanged) {
            currentIndex = state.index;
          }

          final Color contentColor = AppColors.white;

          return Scaffold(
            backgroundColor: backgroundColors[currentIndex],
            body: SafeArea(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: controller,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      context.read<OnBoardingCubit>().changePage(index);
                    },
                    itemBuilder: (context, index) {
                      return pages[index];
                    },
                  ),
                  CustomIndicator(
                    activeIndex: currentIndex,
                    activeColor: contentColor,
                    inactiveColor: contentColor.withOpacity(0.3),
                  ),
                  Positioned(
                    bottom: 30.h,
                    left: 30.w,
                    right: 30.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<OnBoardingCubit>()
                                .completeOnBoarding();
                          },
                          child: Text(
                            "تخطي",
                            style: AppTextStyles.body2Regular.copyWith(
                              color: AppColors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (currentIndex < pages.length - 1) {
                              controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              context
                                  .read<OnBoardingCubit>()
                                  .completeOnBoarding();
                            }
                          },
                          icon: Icon(
                            Icons.arrow_forward,
                            color: contentColor,
                            size: 30.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
