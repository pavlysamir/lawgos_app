import 'package:lowgos_app/core/cashe/cache_helper.dart';
import 'package:lowgos_app/core/cashe/cashe_constance.dart';
import 'package:lowgos_app/features/home/domain/entities/home_user.dart';

abstract class HomeLocalDataSource {
  HomeUser getCachedUser();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  HomeUser getCachedUser() {
    return HomeUser(
      id: CacheHelper.getString(key: CacheConstants.userId) ?? '',
      name: CacheHelper.getString(key: CacheConstants.userName) ?? 'مستخدم',
      profileImage: CacheHelper.getString(key: CacheConstants.userImage),
    );
  }
}
