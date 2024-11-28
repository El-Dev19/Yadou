import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:myapp/forms/forms.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                print("Déconnecté");
              },
              child: const Text("Déconnexion"),
            ),
            const Gap(20),
            ElevatedButton(
              onPressed: () {
                getUserDetails();
              },
              child: const Text("Afficher les détails de l'utilisateur"),
            ),
          ],
        ),
      ),
    );
  }
}
