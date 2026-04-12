import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/core/theme/app_theme.dart';
import 'package:kuttot/core/constants/app_strings.dart';
import 'package:kuttot/core/providers/auth_provider.dart';
import 'package:kuttot/features/shell/presentation/shell_screen.dart';
import 'package:kuttot/features/splash/presentation/splash_screen.dart';
import 'package:kuttot/features/auth/presentation/login_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _showSplash
          ? SplashScreen(
              onComplete: () {
                setState(() {
                  _showSplash = false;
                });
              },
            )
          : const _AuthGate(),
    );
  }
}

/// Watches auth state and routes to Login or Shell accordingly
class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Still checking SharedPreferences — show blank screen (no flash)
    if (authState.status == AuthStatus.checking) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF8F5),
        body: SizedBox.shrink(),
      );
    }

    // Default to ShellScreen (which handles both Guests and Authenticated users)
    return const ShellScreen();
  }
}

