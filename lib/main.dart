import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'themes/app_theme.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/criar_lista_compra_screen.dart';
import 'screens/lista_compras_screen.dart';
import 'screens/listas_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CompreFacilApp());
}

class CompreFacilApp extends StatelessWidget {
  const CompreFacilApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CompreFácil',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/createList': (context) => const CriarListaCompraScreen(),
        '/listaCompras': (context) {
          final nomeList =
              ModalRoute.of(context)?.settings.arguments as String? ??
                  'Minha Lista';
          return ListaComprasScreen(nomeList: nomeList);
        },
        '/listas': (context) => const ListasScreen(),
        '/mapa': (context) => const MapScreen(),
        '/perfil': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
