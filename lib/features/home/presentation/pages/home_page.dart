import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:lowgos_app/features/home/presentation/cubit/home_state.dart';
import 'package:lowgos_app/features/home/presentation/widgets/completed_laws_section.dart';
import 'package:lowgos_app/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:lowgos_app/features/home/presentation/widgets/home_header.dart';
import 'package:lowgos_app/features/home/presentation/widgets/home_section_title.dart';
import 'package:lowgos_app/features/home/presentation/widgets/law_carousel_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHome();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.failure.message)));
            }
          },
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return Center(
                child: TextButton(
                  onPressed: context.read<HomeCubit>().loadHome,
                  child: Text(state.failure.message),
                ),
              );
            }

            final success = state as HomeSuccess;

            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryColor40,
                        AppColors.white,
                        AppColors.white,
                        AppColors.white,
                      ],
                    ),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: context.read<HomeCubit>().loadHome,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: SizedBox(height: 15.h)),

                      /// Header
                      SliverToBoxAdapter(
                        child: HomeHeader(user: success.data.user),
                      ),

                      /// Laws Title
                      const SliverToBoxAdapter(
                        child: HomeSectionTitle(title: 'القوانين', icon: '🔥'),
                      ),

                      /// Carousel
                      SliverToBoxAdapter(
                        child: LawCarouselSection(
                          laws: success.data.laws,
                          selectedIndex: success.selectedLawIndex,
                          isStartingLaw: success.isStartingLaw,
                        ),
                      ),

                      /// Completed Title
                      const SliverToBoxAdapter(
                        child: HomeSectionTitle(
                          title: 'كمل رحلتك في القانون',
                          icon: '⚡',
                        ),
                      ),

                      /// Completed Laws List
                      CompletedLawsSection(laws: success.data.progressLaws),
                    ],
                  ),
                ),

                HomeBottomNavBar(selectedIndex: success.selectedTabIndex),
              ],
            );
          },
        ),
      ),
    );
  }
}
