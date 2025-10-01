import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nde_crm/features/crm_home/home_screen.dart';
import 'package:nde_crm/features/login/bloc/login_screen_bloc.dart';
import 'package:nde_crm/features/login/repo/authrepository.dart';
import 'package:nde_crm/features/login/view/login_screen.dart';
import 'package:nde_crm/utils/messenger/messenger.dart';
import 'package:nde_crm/utils/router/myrouter.dart';

import 'package:nde_crm/utils/view/carousel_screen.dart';
import 'package:nde_crm/utils/view/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// @pragma("vm:entry-point")
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  bool isFirstOpen = prefs.getBool('isFirstOpen') ?? true;
  log("🔍 isFirstOpen (before check): $isFirstOpen");

  if (isFirstOpen) {
    log("✅ First time opening app -> Set isFirstOpen to false");
  } else {
    log("ℹ️ Not the first time opening the app");
  }

  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final refreshToken = prefs.getString('refresh_token');

  log(
    "🔍 Login Status: isLoggedIn = $isLoggedIn, refreshToken = ${refreshToken != null ? 'exists' : 'null'}",
  );

  if (isLoggedIn && refreshToken != null) {
    try {
      final loginBloc = LoginBloc(authRepository: Auth());
      final success = await loginBloc.refreshTokenOnStartup(refreshToken);

      if (!success) {
        log("Token refresh failed, performing clean logout");
        await loginBloc.performCleanLogout();
        isLoggedIn = false;
      }
    } catch (e) {
      log('❌ Token refresh failed on startup: $e');
      await prefs.clear();
      isLoggedIn = false;
    }
  } else {
    log("Skipping token refresh (User not logged in or no refresh token)");
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, isFirstOpen: isFirstOpen));
}

/// Main app widget
class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isFirstOpen;
  const MyApp({super.key, required this.isLoggedIn, required this.isFirstOpen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// --- Bloc Providers ---
        BlocProvider(create: (_) => LoginBloc(authRepository: Auth())),
      ],
      child: MaterialApp(
        navigatorKey: MyRouter.navigatorKey,
        scaffoldMessengerKey: Messenger.rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'NDE CRM',
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
