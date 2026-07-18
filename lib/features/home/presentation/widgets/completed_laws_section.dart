import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/presentation/widgets/completed_law_item.dart';

class CompletedLawsSection extends StatelessWidget {
  const CompletedLawsSection({super.key, required this.laws});

  final List<Law> laws;

  @override
  Widget build(BuildContext context) {
    if (laws.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 22.h),
          child: const Center(child: Text('ابدأ رحلتك مع أول قانون')),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 110.h),
      sliver: SliverList.separated(
        itemCount: laws.length,
        itemBuilder: (context, index) {
          return CompletedLawItem(law: laws[index]);
        },
        separatorBuilder: (_, _) => SizedBox(height: 14.h),
      ),
    );
  }
}
