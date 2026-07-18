class ServerException implements Exception {
  const ServerException([this.message = 'حدث خطأ في الخادم']);

  final String message;
}

class AuthException implements Exception {
  const AuthException([this.message = 'تعذر إتمام عملية المصادقة']);

  final String message;
}
