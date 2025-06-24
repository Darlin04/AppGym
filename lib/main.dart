// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para SystemChrome
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa Firebase Core
import 'package:gym_app/firebase_options.dart'; // Importa las opciones de Firebase generadas por flutterfire
import 'package:gym_app/features/auth/auth_screen.dart'; // Pantalla de Login/Registro
import 'package:gym_app/features/auth/auth_viewmodel.dart'; // ViewModel para la autenticación
import 'package:gym_app/features/dashboard/dashboard_screen.dart'; // Pantalla principal después del login
import 'package:gym_app/common/theme/app_theme.dart'; // Nuestro tema personalizado

void main() async {
  // Asegura que los widgets de Flutter estén inicializados antes de cualquier llamada a platform channels (como Firebase)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase con las opciones de configuración específicas de tu plataforma.
  // Este paso es CRUCIAL para que Firebase funcione.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configura la apariencia de la barra de estado del sistema (arriba de la pantalla).
  // La hace transparente y los íconos oscuros para que contrasten con el fondo claro.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Para Android
      statusBarBrightness: Brightness.light,    // Para iOS
    ),
  );

  runApp(
    // Provee AuthViewModel a toda la aplicación usando Provider.
    // Así, cualquier widget puede acceder a él con context.read<AuthViewModel>().
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
      theme: buildAppTheme(), // Aplica nuestro tema visual personalizado.
      home: const AuthWrapper(), // La pantalla inicial es AuthWrapper, que decide si muestra Login o Dashboard.
      debugShowCheckedModeBanner: false, // Quita la etiqueta "Debug" en la esquina.
    );
  }
}

// --- AuthWrapper: Decide qué pantalla mostrar ---
// Este widget comprueba si el usuario ya está logueado.
// Si lo está, muestra el Dashboard. Si no, muestra la pantalla de Login/Registro.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios en el AuthViewModel para saber si el usuario está logueado.
    final authViewModel = context.watch<AuthViewModel>();

    // Si authViewModel.user no es null, significa que hay un usuario logueado.
    if (authViewModel.user != null) {
      // Navega directamente al Dashboard.
      return const DashboardScreen();
    } else {
      // Si no hay usuario logueado, muestra la pantalla de Autenticación.
      return const AuthScreen();
    }
  }
}