import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:nde_crm/features/login/bloc/login_screen.event.dart';
import 'package:nde_crm/features/login/model/login_req_model.dart';
import 'package:nde_crm/features/login/repo/auth_repo.dart';
import 'package:nde_crm/utils/shared_preference/share_pref.dart';

import 'package:shared_preferences/shared_preferences.dart';


import 'login_screen_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Auth authRepository;

  Timer? _refreshTimer;
  // Timer? _refreshTimer;
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginApi>(_onLoginSubmitted);
    on<LoginLoggedOut>(_onLogout);
    on<LoginStatusReset>(_onStatusReset);
    on<LoginRefresh>(_onRefreshToken);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onLoginSubmitted(
    LoginApi event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, message: ""));

    try {
      final loginRequest = LoginRequestModel(
        email: event.email,
        password: event.password,
      );

      final response = await authRepository.login(loginRequest);
      log(response.toString());

      // Start a new periodic refresh timer
      _refreshTimer = Timer.periodic(const Duration(minutes: 4, seconds: 20), (
        _,
      ) {
        if (!_isRefreshing) {
          log('🔁 Token refresh triggered');
          add(LoginRefresh());
        }
      });

      emit(
        state.copyWith(
          status: LoginStatus.success,
          message: "Login successful!",
        ),
      );
    } catch (e, stackTrace) {
      log("❌ Unhandled login error: $e", stackTrace: stackTrace);
      emit(
        state.copyWith(
          status: LoginStatus.errorScreen,
          message: "An unexpected error occurred. Please try again.",
          hasSubmitted: true,
        ),
      );
    }
  }

  void _onStatusReset(LoginStatusReset event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.initial));
  }

  Future<void> _onLogout(LoginLoggedOut event, Emitter<LoginState> emit) async {
    await performCleanLogout();

    emit(const LoginState());
  }

  Future<void> performCleanLogout() async {
    _refreshTimer?.cancel();
    _refreshTimer = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> refreshTokenOnStartup(String refreshToken) async {
    if (_isRefreshing) return false;

    _isRefreshing = true;
    try {
      log('Refreshing token on app startup...');

      final response = await http.post(
        Uri.parse("https://api.nowdigitaleasy.com/auth/v1/auth/refresh-token"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        await UserPreferences.updateTokens(newAccessToken, newRefreshToken);
        log('Tokens refreshed successfully on startup');

        _startRefreshTimer();
        return true;
      } else {
        log('  Token refresh failed on startup: ${response.body}');
        return false;
      }
    } catch (e) {
      log('  Error refreshing token on startup: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _onRefreshToken(
    LoginRefresh event,
    Emitter<LoginState> emit,
  ) async {
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer();

    try {
      final refreshToken = await UserPreferences.getrefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception('No refresh token available');
      }

      log('Refreshing token...');
      final response = await http.post(
        Uri.parse("https://api.nowdigitaleasy.com/auth/v1/auth/refresh-token"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        await UserPreferences.updateTokens(newAccessToken, newRefreshToken);
        log('Tokens refreshed successfully');

        _refreshCompleter!.complete();
      } else if (response.statusCode == 401) {
        log('401 Unauthorized: redirecting to login');
        emit(state.copyWith(status: LoginStatus.unauthorized));
        _refreshCompleter?.completeError(Exception("Unauthorized"));
        add(LoginLoggedOut()); 
      } else {
        _refreshCompleter?.completeError(Exception("Failed to refresh token"));
        throw Exception("Failed to refresh token");
      }
    } catch (e) {
      log('Error during token refresh: $e');
      emit(state.copyWith(status: LoginStatus.unauthorized));
      add(LoginLoggedOut());
      _refreshCompleter?.completeError(e);
    } finally {
      _isRefreshing = false;
    }
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 4, seconds: 20), (
      _,
    ) {
      if (!_isRefreshing) {
        log('Periodic token refresh triggered');
        add(LoginRefresh());
      }
    });
  }
}