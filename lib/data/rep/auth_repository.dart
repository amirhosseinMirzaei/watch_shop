import 'package:flutter/cupertino.dart';
import 'package:nike2/common/exceptions.dart';
import 'package:nike2/data/auth_info.dart';
import 'package:nike2/data/source/auth_data_source.dart';

import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemoteDataSource());

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> refreshToken();
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(
    this.dataSource,
  );
  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _persistAuthTokens(authInfo);

    debugPrint("access token is: ${authInfo.accessToken}");
  }

  @override
  Future<void> signUp(String username, String password) async {
    final AuthInfo authInfo = await dataSource.signUp(username, password);
    _persistAuthTokens(authInfo);
    debugPrint("access token is: ${authInfo.accessToken}");
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifier.value != null) {
      final AuthInfo authInfo = await dataSource
          .refreshToken(authChangeNotifier.value!.refreshToken!);
      debugPrint('refresh token is: ${authInfo.refreshToken}');
      _persistAuthTokens(authInfo);
    }
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("accessToken", authInfo.accessToken);
    if (authInfo.refreshToken != null) {
      sharedPreferences.setString("refreshToken", authInfo.refreshToken!);
    }
    sharedPreferences.setString("email", authInfo.email);
    authChangeNotifier.value =
        AuthInfo(authInfo.accessToken, authInfo.refreshToken, authInfo.email);
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken = sharedPreferences.getString("accessToken") ?? '';

    final String? refreshToken = sharedPreferences.getString("refreshToken");
    if (accessToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(
          accessToken, refreshToken, sharedPreferences.getString('email')!);
    }
  }

  @override
  Future<void> signOut() async {
    final sucess = await dataSource.logout();
    if (!sucess) {
      throw AppException(message: "Could not logout, check connection!");
    }
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    authChangeNotifier.value = null;
  }
}
