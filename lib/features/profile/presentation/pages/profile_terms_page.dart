import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';

class ProfileTermsPage extends StatelessWidget {
  const ProfileTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryColor40,
                AppColors.white,

                AppColors.whiteLight,
                AppColors.white,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'الشروط و الاحكام',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h3Bold.copyWith(
                    color: AppColors.blue,
                    fontSize: 30.sp,
                  ),
                ),
                SizedBox(height: 18.h),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      _termsText,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.body3Regular.copyWith(
                        color: AppColors.navyBlue300,
                        height: 1.22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _termsText = '''
شروط وأحكام الاستخدام
آخر تحديث: [اكتب التاريخ]
مرحبا بك في تطبيق [اسم التطبيق]. باستخدامك للتطبيق فإنك توافق على الالتزام بالشروط والأحكام التالية، وفي حال عدم موافقتك على أي جزء منها يرجى عدم استخدام التطبيق.

1. تعريف التطبيق
تطبيقي [اسم التطبيق] هو منصة إلكترونية تهدف إلى تسهيل التواصل والتعاون بين المحامين، وتقديم خدمات قانونية ومهنية متنوعة، بما يشمل تبادل الخدمات القانونية، فرص العمل، والتواصل المهني.

2. أهلية الاستخدام
يقر المستخدم بأنه:
• بالغ من العمر 18 عاما أو أكثر.
• يمتلك الأهلية القانونية الكاملة.
• في حال استخدام خدماته فإنه مسؤول عن صحة بياناته المهنية والنقابية.

3. الحسابات والتسجيل
• يلتزم المستخدم بتقديم بيانات صحيحة ودقيقة وحديثة.
• يتحمل المستخدم مسؤولية الحفاظ على سرية بيانات تسجيل الدخول الخاصة به.
• يحق لإدارة التطبيق تعليق أو حذف أي حساب يحتوي على معلومات مضللة أو نشاط مخالف.

4. استخدام التطبيق
يوافق المستخدم على عدم:
• استخدام التطبيق في أي نشاط غير قانوني.
• نشر محتوى مسيء أو تشهيري أو مخالف للآداب العامة.
• انتحال صفة أي شخص أو جهة.
• محاولة اختراق التطبيق أو الوصول غير المصرح به للأنظمة.
• إساءة استخدام خدمات التواصل أو إزعاج المستخدمين الآخرين.

5. الخدمات القانونية
• التطبيق يوفر وسيلة للتواصل ولا يعد بديلا عن الاستشارة القانونية المتخصصة.
• يتحمل كل مستخدم مسؤولية الخدمات أو المعلومات التي يقدمها من خلال التطبيق.
• لا تتحمل إدارة التطبيق مسؤولية أي اتفاقات تتم خارج نطاق التطبيق.

6. المحتوى والملكية الفكرية
• يحتفظ التطبيق بجميع حقوق الملكية الفكرية المتعلقة بالتصميم، العلامات، النصوص، والبرمجيات.
• لا يجوز نسخ أو إعادة نشر أي محتوى من التطبيق دون إذن مسبق.

7. الخصوصية
نلتزم بحماية بيانات المستخدمين وفقا لسياسة الخصوصية الخاصة بالتطبيق، وقد يتم استخدام البيانات لتحسين الخدمة أو لأغراض تشغيلية وقانونية.

8. تعديل الشروط
تحتفظ إدارة التطبيق بحق تعديل هذه الشروط في أي وقت، ويعد استمرار استخدام التطبيق بعد التعديل موافقة على الشروط المحدثة.

9. إنهاء الاستخدام
يحق لإدارة التطبيق إيقاف أو حذف حساب أي مستخدم يخالف هذه الشروط أو يسيء استخدام التطبيق.
''';
