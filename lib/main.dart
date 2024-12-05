import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/all_pages/profile_Ui/pages_profile/profile.dart'; 
import 'package:myapp/all_pages/screens_home/home_page.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/forms/forms.dart';
import 'package:myapp/forms/ui_forms/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router, // Utilisez l'objet GoRouter configuré
      title: 'Yadou_App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

// Configuration de GoRouter
final GoRouter _router = GoRouter(
  initialLocation: '/auth', // La route initiale
  routes: [
    // Route pour l'écran de connexion/inscription
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthStateScreen(),
    ),
    // Route pour la page principale (après connexion)
    GoRoute(
      path: '/home',
      builder: (context, state) => MainNavigationPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),

    GoRoute(
      path: '/change-password',
      builder: (context, state) => ChangePasswordScreen(),
    ),
  ],
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isAuthenticated = user != null;

    // Redirigez selon l'état d'authentification
    if (state.uri.toString() == '/auth' && isAuthenticated) {
      return '/home'; // Redirigez vers la page principale si l'utilisateur est connecté
    } else if (state.uri.toString() == '/home' && !isAuthenticated) {
      return '/auth'; // Redirigez vers la connexion si l'utilisateur est déconnecté
    }
    return null; // Pas de redirection
  },
);

class AuthStateScreen extends StatelessWidget {
  const AuthStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          // Naviguez vers la page principale
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/home');
          });
          return const SizedBox(); // Placeholder pendant la redirection
        } else {
          // Affichez le formulaire d'authentification
          return const AuthForm();
        }
      },
    );
  }
}
