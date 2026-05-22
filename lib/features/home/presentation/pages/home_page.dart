import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/di/injection.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:lowgos_app/features/home/presentation/cubit/home_state.dart';
import 'package:lowgos_app/features/home/presentation/cubit/leaderboard_cubit.dart';
import 'package:lowgos_app/features/home/presentation/widgets/completed_laws_section.dart';
import 'package:lowgos_app/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:lowgos_app/features/home/presentation/widgets/home_header.dart';
import 'package:lowgos_app/features/home/presentation/widgets/home_section_title.dart';
import 'package:lowgos_app/features/home/presentation/widgets/law_carousel_section.dart';
import 'package:lowgos_app/features/home/presentation/pages/leaderboard_page.dart';

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
      child: BlocProvider(
        create: (context) => getIt<LeaderboardCubit>(),
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
                  IndexedStack(
                    index: success.selectedTabIndex,
                    children: [
                      _HomeTab(success: success),
                      LeaderboardPage(
                        laws: success.data.laws,
                        isActive: success.selectedTabIndex == 1,
                      ),
                      const _ComingSoonTab(title: 'الملف الشخصي'),
                    ],
                  ),
                  HomeBottomNavBar(selectedIndex: success.selectedTabIndex),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.success});

  final HomeSuccess success;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<HomeCubit>().loadHome,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 15.h)),
          SliverToBoxAdapter(child: HomeHeader(user: success.data.user)),
          const SliverToBoxAdapter(
            child: HomeSectionTitle(title: 'القوانين', icon: '🔥'),
          ),
          SliverToBoxAdapter(
            child: LawCarouselSection(
              laws: success.data.laws,
              selectedIndex: success.selectedLawIndex,
              isStartingLaw: success.isStartingLaw,
            ),
          ),
          const SliverToBoxAdapter(
            child: HomeSectionTitle(title: 'كمل رحلتك في القانون', icon: '⚡'),
          ),
          CompletedLawsSection(laws: success.data.progressLaws),
          SliverToBoxAdapter(child: SizedBox(height: 110.h)),
        ],
      ),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
