class ValidationHandling {
  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(email)) {
      return 'برجاء إدخال بريد إلكتروني صحيح';
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

  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (password.length < 8) {
      return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    final error = validatePassword(value);
    if (error != null) return error;
    if (value != password) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }
}

String? conditionOfValidationPassWord(String? value) {
  // RegExp regex =
  //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final passNonNullValue = value ?? "";
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

String? conditionOfValidationName(String? value) {
  final nonNullValue = value ?? '';
  if (nonNullValue.isEmpty) {
    return 'اسم المستخدم مطلوب';
  }

  // تقسيم الاسم إلى مقاطع باستخدام المسافات
  final List<String> nameParts = nonNullValue.split(' ');

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

  return null;
}
