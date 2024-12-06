import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart'; // Importez go_router
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

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Déconnexion
      context
          .go('/auth'); // Redirection vers la page de connexion avec go_router
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de déconnexion : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile User"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_user != null) ...[
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profile2.webp"),
                ),
                const Gap(10),
                Text(
                  _user?.email ?? 'Email inconnu',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                // const Gap(8),
                const Card(
                  margin: EdgeInsets.all(16),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("Edit Profile"),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
                const Gap(16),
                const Card(
                  margin: EdgeInsets.all(16),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("Paramètres"),
                    trailing: Icon(Icons.settings),
                  ),
                ),
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
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: Text(
                            _user?.email ?? 'Email inconnu',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: Column(
                            children: [
                              if (_user?.photoURL != null)
                                Column(
                                  children: [
                                    Image.network(_user!.photoURL!),
                                  ],
                                ),
                              if (_user?.photoURL == null)
                                const Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/profile.png"),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          title: Text(
                            _user?.displayName ?? 'Utilisateur',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        // Text("Email : ${_user?.email ?? 'Non défini'}"),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                const Text("Aucun utilisateur connecté."),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Déconnexion"),
                        content: const Text(
                            'Etes-vous sûr de vouloir vous déconnecter ?'),
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
                              Navigator.of(context).pop(); // Ferme le dialogue
                              _signOut(
                                  context); // Déconnecte l'utilisateur et redirige
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
                onPressed: () {
                  context.go(
                      '/change-password'); // Redirige vers la page de changement de mot de passe
                },
                child: const Text("Changer de mot de passe"),
              ),
              const Gap(10),
              const DeleteUser(), // Composant de suppression d'utilisateur
            ],
          ),
        ),
      ),
    );
  }
}
