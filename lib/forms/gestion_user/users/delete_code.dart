// Exemple de Widget pour la suppression de compte
import 'package:flutter/material.dart';
import '../../../data/emails/emails.dart';

class DeleteUser extends StatefulWidget {
  const DeleteUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeleteUserState createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  final AccountDeletionHandler _deletionHandler = AccountDeletionHandler();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supprimer Mon Compte"),
        centerTitle: true,
      ),
      body: Center(
        child: ValueListenableBuilder<AccountDeletionStatus>(
          valueListenable: _deletionHandler.status,
          builder: (context, status, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Champs de saisie si réauthentification requise
                if (status == AccountDeletionStatus.requiresRecentLogin) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Bouton de suppression
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: status == AccountDeletionStatus.processing
                      ? null
                      : () async {
                          if (status ==
                              AccountDeletionStatus.requiresRecentLogin) {
                            // Réauthentification et suppression
                            await _deletionHandler.reAuthenticateAndDelete(
                                _emailController.text.trim(),
                                _passwordController.text);
                          } else {
                            // Tentative de suppression directe
                            await _deletionHandler.deleteAccount();
                          }

                          // Gérer le résultat
                          if (_deletionHandler.status.value ==
                              AccountDeletionStatus.success) {
                            // Naviguer vers l'écran de connexion
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (route) => false);
                          }
                        },
                  child: const Text('Supprimer mon compte'),
                ),

                // Indicateurs d'état
                if (status == AccountDeletionStatus.processing)
                  const CircularProgressIndicator(),

                if (status == AccountDeletionStatus.error)
                  Text(
                    _deletionHandler.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
