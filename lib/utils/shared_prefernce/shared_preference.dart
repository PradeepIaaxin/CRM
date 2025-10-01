import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nde_crm/features/login/model/login_model.dart';
import 'package:nde_crm/features/login/view/login_screen.dart';
import 'package:nde_crm/utils/router/myrouter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String userKey = 'user_data';
  static const String tokenKey = 'access_token';
  static const String refrshToken = 'refresh_token';
  static const String workspaceKey = 'default_workspace';
  static const String usernameKey = 'username';
  static const String emailKey = 'email';
  static const String profilePicKey = 'profile_pic_key';
  static const String isLoggedInKey = 'isLoggedIn';
  static const String meiliTenantTokenKey = 'meili_tenant_token';
  static const String userIdKey = 'user_id';

  /// **Save user data in SharedPreferences**
  static Future<void> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());

    await prefs.setString(userKey, userJson);
    await prefs.setString(tokenKey, user.accessToken);
    await prefs.setString(refrshToken, user.refrshToken);
    await prefs.setString(meiliTenantTokenKey, user.meiliTenantToken);
    await prefs.setString(workspaceKey, user.defaultWorkspace);
    await prefs.setString(usernameKey, user.fullName);
    await prefs.setString(emailKey, user.email);
    await prefs.setString(profilePicKey, user.profilePicUrl);
    await prefs.setBool(isLoggedInKey, true);
    await prefs.setString(userIdKey, user.userId);
  }

  /// **Get Access Token**
  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> updateTokens(
    String accessToken,
    String refreshToken,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, accessToken);
    await prefs.setString(refrshToken, refreshToken);
  }

  static Future<String?> getrefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(refrshToken);
  }

  /// **Get User ID**
  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  static Future<String?> getMeiliTenantToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(meiliTenantTokenKey);
  }

  /// **Get Default Workspace**
  static Future<String?> getDefaultWorkspace() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(workspaceKey);
  }

  /// **Get Username**
  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  /// **Get Email**
  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  /// **Get Profile Picture Key**
  static Future<String?> getProfilePicKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(profilePicKey);
  }

  /// **Get User Model**
  static Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(userKey);

    if (userJson != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        log(" Error decoding user data: $e");
      }
    }
    return null;
  }

  static Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
    await prefs.remove(tokenKey);
    await prefs.remove(workspaceKey);
    await prefs.remove(usernameKey);
    await prefs.remove(emailKey);
    await prefs.remove(profilePicKey);
    log("User logged out and data cleared.");
  }

  static Future<void> logout(BuildContext context) async {
    await clearUser();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    MyRouter.pushRemoveUntil(screen: LoginScreen());

    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => BlocProvider(
    //       create: (context) => LoginBloc(authRepository: Auth()),
    //       child: const LoginScreen(),
    //     ),
    //   ),
    //   (route) => false,
    // );
  }
}
