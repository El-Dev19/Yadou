import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/all_pages/screens_home/home_page.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;

  const EmailVerificationScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    // Vérifier périodiquement si l'email est vérifié
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await widget.user.reload();
      if (widget.user.emailVerified) {
        timer.cancel();
        // Naviguer vers la page principale
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => MainNavigationPage())
        );
      }
    });

    // Permettre de renvoyer l'email après 30 secondes
    Future.delayed(Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resendVerificationEmail() async {
    try {
      await widget.user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email de vérification renvoyé'))
      );
      setState(() {
        _canResend = false;
      });
      // Réactiver le bouton après 30 secondes
      Future.delayed(Duration(seconds: 30), () {
        if (mounted) {
          setState(() {
            _canResend = true;
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi de l\'email'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vérification d\'email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Un email de vérification a été envoyé à ${widget.user.email}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text('Veuillez cliquer sur le lien dans l\'email pour vérifier votre compte'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _canResend ? _resendVerificationEmail : null,
              child: const Text('Renvoyer l\'email de vérification'),
            ),
          ],
        ),
      ),
    );
  }
}