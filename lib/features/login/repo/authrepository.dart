import 'dart:developer';

import 'package:nde_crm/features/login/model/login_model.dart';
import 'package:nde_crm/features/login/model/login_req_model.dart';
import 'package:nde_crm/utils/dio/dio.dart';
import 'package:nde_crm/utils/messenger/messenger.dart';

class Auth {
  final NetworkUtils _network;

  Auth({NetworkUtils? network}) : _network = network ?? NetworkUtils();

  Future<bool> checkUserEmail(String email) async {
    try {
      final response = await _network.request(
        endpoint: '/auth/v1/auth/user/$email',
        method: HttpMethod.get,
      );

      if (response == null) return false;

      final statusCode = response.statusCode ?? 0;
      final data = response.data;

      log("Response: $data");

      if (statusCode == 200 || statusCode == 201) {
        Messenger.alertSuccess("Email verified successfully");
        return true;
      } else if (statusCode == 404) {
        Messenger.alertError(" Email not found. Please check and try again.");
        return false;
      } else {
        Messenger.alertError(" Unexpected error");
        return false;
      }
    } catch (e) {
      log("❌ checkUserEmail Error: $e");
      Messenger.alertError("Something went wrong. Try again.");
      return false;
    }
  }

  ///  Login user
  Future<UserModel?> login(LoginRequestModel loginRequest) async {
    try {
      final response = await _network.request(
        endpoint: '/auth/v1/auth/signin',
        method: HttpMethod.post,
        data: loginRequest.toJson(),
      );

      if (response == null) return null;

      final statusCode = response.statusCode ?? 0;
      final data = response.data;

      log(" Login Response: $data");

      if (statusCode == 200) {
        Messenger.alertSuccess("Logged in successfully");
        final user = UserModel.fromJson(data);
        return user;
      } else if (statusCode == 401) {
        Messenger.alertError(" Invalid credentials. Please try again.");
        return null;
      } else {
        Messenger.alertError("Login failed ");
        return null;
      }
    } catch (e) {
      log("❌ Login error: $e");
      Messenger.alertError("Unexpected error during login.");
      return null;
    }
  }
}
