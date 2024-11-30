// import 'package:firebase_auth/firebase_auth.dart';
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
                if (signOut != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:
                            Text("Etes vous sur de vouloir vous deconnecter ?"),
                        content: Text('Voici le contenu de votre message'),
                        actions: [
                          TextButton(
                            child: Text('Non'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Ferme le dialogue
                            },
                          ),
                          TextButton(
                            child: Text('Oui'),
                            onPressed: () {
                              signOut(); // Ferme le dialogue
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
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
