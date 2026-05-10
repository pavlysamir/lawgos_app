import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/auth_primary_button.dart';

void main() {
  testWidgets('Auth primary button renders label', (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            home: Scaffold(
              body: AuthPrimaryButton(
                text: 'تسجيل الدخول',
                isLoading: false,
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );

    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });
}
