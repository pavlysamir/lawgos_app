import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/presentation/cubit/leaderboard_cubit.dart';
import 'package:lowgos_app/features/home/presentation/cubit/leaderboard_state.dart';
import 'package:lowgos_app/features/home/presentation/widgets/current_user_rank_card.dart';
import 'package:lowgos_app/features/home/presentation/widgets/leaderboard_filter_dropdown.dart';
import 'package:lowgos_app/features/home/presentation/widgets/leaderboard_podium.dart';
import 'package:lowgos_app/features/home/presentation/widgets/leaderboard_rank_table.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({
    super.key,
    required this.laws,
    required this.isActive,
  });

  final List<Law> laws;
  final bool isActive;

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      context.read<LeaderboardCubit>().load(laws: widget.laws);
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant LeaderboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((!oldWidget.isActive && widget.isActive) ||
        (widget.isActive && oldWidget.laws != widget.laws)) {
      context.read<LeaderboardCubit>().load(laws: widget.laws);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 180.h;
    if (_scrollController.offset >= threshold) {
      context.read<LeaderboardCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaderboardCubit, LeaderboardState>(
      listener: (context, state) {
        if (state is LeaderboardError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.message)));
        }
      },
      builder: (context, state) {
        if (state is LeaderboardLoading || state is LeaderboardInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LeaderboardError) {
          return Center(
            child: TextButton(
              onPressed: () =>
                  context.read<LeaderboardCubit>().load(laws: widget.laws),
              child: Text(state.failure.message),
            ),
          );
        }

        final success = state as LeaderboardSuccess;
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => context.read<LeaderboardCubit>().load(
                laws: widget.laws,
                lawId: success.selectedLawId,
              ),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 70.h)),
                  SliverToBoxAdapter(
                    child: LeaderboardPodium(entries: success.topEntries),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 26.h)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: LeaderboardFilterDropdown(
                        laws: success.laws,
                        selectedLawId: success.selectedLawId,
                        onChanged: context.read<LeaderboardCubit>().changeLaw,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 26.h)),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: success.currentUserEntry == null ? 106.h : 178.h,
                    ),
                    sliver: LeaderboardRankTable(
                      entries: success.entries,
                      isLoadingMore: success.isLoadingMore,
                    ),
                  ),
                ],
              ),
            ),
            if (success.currentUserEntry != null)
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 92.h,
                child: CurrentUserRankCard(entry: success.currentUserEntry!),
              ),
          ],
        );
      },
    );
  }
}
