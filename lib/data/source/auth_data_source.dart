import 'package:dio/dio.dart';
import 'package:nike2/common/api_keys.dart';
import 'package:nike2/common/exceptions.dart';
import 'package:nike2/data/auth_info.dart';
import 'package:nike2/data/common/response_validator.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<bool> logout();
  Future<AuthInfo> signUp(String username, String password);
  Future<AuthInfo> refreshToken(String token);
}

class AuthRemoteDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  ParseUser? user;

  @override
  Future<AuthInfo> login(String username, String password) async {
    user = ParseUser(username, password, null);
    final ParseResponse response = await user!.login();

    if (!response.success) throw AppException(message: response.error!.message);

    final String? refreshToken =
        (response.result as ParseObject).containsKey("refreshToken")
            ? response.result["refreshToken"]
            : null;

    await Parse().initialize(
      ApiKeys.applicationId,
      ApiKeys.parseServerUrl,
      clientKey: ApiKeys.clientKey,
      autoSendSessionId: true,
      sessionId: (response.result as ParseObject).get("sessionToken"),
      debug: true,
    );

    return AuthInfo(
        (response.result as ParseObject).get("sessionToken"),
        // response.result["refreshToken"],
        refreshToken,
        username);
  }

// not implemented
  @override
  Future<AuthInfo> refreshToken(String token) async {
    // final response = await httpClient.post("auth/token", data: {
    //   "grant_type": "refreshToken",
    //   "refreshToken": token,
    //   "client_id": 2,
    //   "client_secret": Constants.clientSecret
    // });
    final response = Response(requestOptions: RequestOptions());

    validateResponse(response);

    return AuthInfo(
        response.data["accessToken"], response.data["refreshToken"], '');
  }

  @override
  Future<AuthInfo> signUp(String username, String password) async {
    user = ParseUser(username, password, username);
    final ParseResponse response = await user!.signUp();
    if (!response.success) throw AppException(message: response.error!.message);

    return login(username, password);
  }

  @override
  Future<bool> logout() async {
    final resp = await user!.logout();
    return resp.success;
  }
}
