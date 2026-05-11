import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/presentation/cubit/law_levels_cubit.dart';
import 'package:lowgos_app/features/home/presentation/cubit/law_levels_state.dart';
import 'package:lowgos_app/features/home/presentation/widgets/law_levels_app_bar.dart';
import 'package:lowgos_app/features/home/presentation/widgets/law_levels_header.dart';
import 'package:lowgos_app/features/home/presentation/widgets/law_levels_list.dart';

class LawLevelsPage extends StatefulWidget {
  const LawLevelsPage({super.key, required this.law});

  final Law law;

  @override
  State<LawLevelsPage> createState() => _LawLevelsPageState();
}

class _LawLevelsPageState extends State<LawLevelsPage> {
  @override
  void initState() {
    super.initState();
    context.read<LawLevelsCubit>().loadLevels(widget.law);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocConsumer<LawLevelsCubit, LawLevelsState>(
          listener: (context, state) {
            if (state is LawLevelsError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.failure.message)));
            }
          },
          builder: (context, state) {
            if (state is LawLevelsLoading || state is LawLevelsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LawLevelsError) {
              return Center(
                child: TextButton(
                  onPressed: () {
                    context.read<LawLevelsCubit>().loadLevels(widget.law);
                  },
                  child: Text(state.failure.message),
                ),
              );
            }

            final success = state as LawLevelsSuccess;
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColor40,
                    AppColors.white,
                    AppColors.white,
                  ],
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: LawLevelsAppBar()),
                  SliverToBoxAdapter(
                    child: LawLevelsHeader(law: success.data.law),
                  ),
                  LawLevelsList(
                    levels: success.data.levels,
                    openingLevelNumber: success.openingLevelNumber,
                    onLevelTap: context.read<LawLevelsCubit>().enterLevel,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
