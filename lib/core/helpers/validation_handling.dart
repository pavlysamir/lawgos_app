class ValidationHandling {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return '*Name should contain letters only.';
    }
    return null;
  }
}

String? conditionOfValidationPassWord(value) {
  // RegExp regex =
  //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  var passNonNullValue = value ?? "";
  if (passNonNullValue.isEmpty) {
    return ("كلمة المرور مطلوبة");
  } else if (passNonNullValue.length < 8) {
    return ("يجب أن تكون كلمة المرور أكثر من 8 أحرف");
  }
  //  else if (!regex.hasMatch(passNonNullValue)) {
  //   return ("كلمه المرور يجب ان تتضمن الشروط المطلوبه");
  // }
  return null;
}

String? conditionOfValidationName(value) {
  var nonNullValue = value ?? '';
  if (nonNullValue.isEmpty) {
    return 'اسم المستخدم مطلوب';
  }

  // تقسيم الاسم إلى مقاطع باستخدام المسافات
  List<String> nameParts = nonNullValue.split(' ');

  // التحقق من عدد المقاطع
  if (nameParts.length < 3) {
    return 'الاسم يجب أن يكون مكونًا من ثلاث مقاطع على الأقل';
  }

  return null;
}

String? validateAndFormatPhone(String? value, {String? defaultCountryCode}) {
  if (value == null || value.trim().isEmpty) {
    return 'الهاتف مطلوب';
  }

  String phone = value.trim();

  // Remove spaces, dashes, parentheses
  phone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

  // If number starts with 0 and default country code is provided, convert it
  if (phone.startsWith('0')) {
    phone = defaultCountryCode! + phone.substring(1);
  }
  // If number starts with +, keep it as is
  else if (phone.startsWith('+')) {
    // do nothing
  } else {
    return 'رقم الهاتف غير صالح';
  }

  // General phone validation: + followed by 6-15 digits (typical E.164 format)
  if (!RegExp(r'^\+\d{6,15}$').hasMatch(phone)) {
    return 'رقم الهاتف يجب أن يكون صالح ويحتوي على كود الدولة ورقم صحيح';
  }

  print('Formatted Phone: $phone'); // For testing
  return null;
}
