import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nde_crm/features/crm_home/home_screen.dart';
import 'package:nde_crm/features/login/bloc/login_screen_bloc.dart';
import 'package:nde_crm/features/login/repo/auth_repo.dart';
import 'package:nde_crm/features/login/view/login_screen.dart';
import 'package:nde_crm/utils/router/router.dart';
import 'package:nde_crm/utils/snackbar/snackbar.dart';
import 'package:nde_crm/utils/view/carousel_screen.dart';
import 'package:nde_crm/utils/view/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  bool isFirstOpen = prefs.getBool('isFirstOpen') ?? true;
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final refreshToken = prefs.getString('refresh_token');

  log("🔍 isFirstOpen: $isFirstOpen");
  log(
    "🔍 isLoggedIn: $isLoggedIn, refreshToken = ${refreshToken != null ? 'exists' : 'null'}",
  );

  // Mark first open as false after launch
  if (isFirstOpen) {
    await prefs.setBool('isFirstOpen', false);
  }

  // Try refreshing token if logged in
  if (isLoggedIn && refreshToken != null) {
    try {
      final loginBloc = LoginBloc(authRepository: Auth());
      final success = await loginBloc.refreshTokenOnStartup(refreshToken);

      if (!success) {
        log("❌ Token refresh failed, performing logout");
        await loginBloc.performCleanLogout();
        isLoggedIn = false;
      }
    } catch (e) {
      log("❌ Error refreshing token: $e");
      await prefs.clear();
      isLoggedIn = false;
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, isFirstOpen: isFirstOpen));
}

/// Main App widget
class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isFirstOpen;

  const MyApp({super.key, required this.isLoggedIn, required this.isFirstOpen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(authRepository: Auth())),
      ],
      child: MaterialApp(
        navigatorKey: MyRouter.navigatorKey,
        scaffoldMessengerKey: Messenger.rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'NDE CRM',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/Splashscreen',
        routes: {
          '/': (_) => const SplashScreen(),
          '/Splashscreen': (_) => const SplashScreen(),
          '/CarouselScreen': (_) => const CarouselScreen(),
          '/home': (_) => const HomeScreen(),
          '/login': (_) => const LoginScreen(),
        },
      ),
    );
  }
}
