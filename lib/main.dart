// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gym_app/firebase_options.dart';
import 'package:gym_app/features/auth/auth_screen.dart';
import 'package:gym_app/features/auth/auth_viewmodel.dart';
import 'package:gym_app/features/dashboard/dashboard_screen.dart'; // Importa el Dashboard
import 'package:gym_app/common/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym App',
      theme: buildAppTheme(),
      home: const AuthWrapper(), // El home ahora es el AuthWrapper
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios en el estado del usuario
    final authViewModel = context.watch<AuthViewModel>();

    if (authViewModel.user != null) {
      // Si el usuario está logueado, muestra el Dashboard
      return const DashboardScreen();
    } else {
      // Si no, muestra la pantalla de Login
      return const AuthScreen();
    }
  }
}