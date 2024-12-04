import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:myapp/forms/forms.dart';
import 'package:myapp/forms/gestion_user/users/delete_code.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user; // Variable pour stocker les informations de l'utilisateur.

  @override
  void initState() {
    super.initState();
    _getUserDetails(); // Récupération des détails de l'utilisateur à l'ouverture de la page.
  }

  void _getUserDetails() {
    setState(() {
      _user =
          FirebaseAuth.instance.currentUser; // Obtenez l'utilisateur connecté.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des utilisateurs"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user != null) ...[
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Détails de l'utilisateur :",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text("Email : ${_user?.email ?? 'Non défini'}"),
                      Text("Nom : ${_user?.displayName ?? 'Non défini'}"),
                      // Text("ID utilisateur : ${_user?.uid ?? 'Non défini'}"),
                      if (_user?.photoURL != null)
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            const Text("Photo de profil :"),
                            const SizedBox(height: 8),
                            Image.network(_user!.photoURL!),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              const Text("Aucun utilisateur connecté."),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Déconnexion"),
                      content: const Text(
                          'Etes vous sur de vouloir vous déconnecter ?'),
                      actions: [
                        TextButton(
                          child: const Text('Non'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Ferme le dialogue
                          },
                        ),
                        TextButton(
                          child: const Text('Oui'),
                          onPressed: () {
                            signOut(); // Ferme le dialogue
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Déconnexion"),
            ),
            const Gap(10),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Changer de mot de passe"),
                      content: const Text(
                          'Etes vous sur de vouloir changer de mot de passe ?'),
                      actions: [
                        TextButton(
                          child: const Text('Non'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Ferme le dialogue
                          },
                        ),
                        TextButton(
                          child: const Text('Oui'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen(),
                              ),
                            );
                            // Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Changer de Mot de passe"),
            ),
            DeleteUser(),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const DeleteUser(),
            //       ),
            //     );
            //   },
            //   label: Text('Supprimer'),
            //   icon: Icon(Icons.delete),
            // )
          ],
        ),
      ),
    );
  }
}
