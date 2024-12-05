import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteUser extends StatefulWidget {
  const DeleteUser({super.key});

  @override
  _DeleteUserState createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  // Méthode pour afficher un message temporaire
  void _showSnackbar(String message, {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  // Méthode principale pour supprimer un utilisateur
  Future<void> deleteUser() async {
    try {
      // Demander confirmation à l'utilisateur
      bool confirmDelete = await _showConfirmationDialog();
      if (!confirmDelete) return; // L'utilisateur a annulé l'opération

      // Obtenir l'utilisateur actuel
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnackbar("Aucun utilisateur connecté");
        return;
      }

      // Réauthentifier l'utilisateur
      await _reAuthenticateUser();

      // Supprimer les données utilisateur de Firestore
      await _deleteUserData(user.uid);

      // Supprimer le compte utilisateur de Firebase
      await user.delete();

      // Déconnecter l'utilisateur
      await FirebaseAuth.instance.signOut();

      // Redirection vers l'écran de connexion
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);

      _showSnackbar(
        "Compte supprimé avec succès",
        backgroundColor: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    } catch (e) {
      _showSnackbar("Une erreur est survenue. Veuillez réessayer.");
      print("Erreur inattendue : $e");
    }
  }

  // Gérer les exceptions spécifiques à Firebase
  void _handleFirebaseAuthException(FirebaseAuthException e) {
    String errorMessage = "Erreur lors de la suppression du compte";
    if (e.code == 'requires-recent-login') {
      errorMessage = "Veuillez vous reconnecter pour supprimer votre compte.";
    } else if (e.code == 'user-not-found') {
      errorMessage = "Utilisateur introuvable.";
    }
    _showSnackbar(errorMessage);
    print("FirebaseAuthException : ${e.code}");
  }

  // Réauthentifier l'utilisateur pour des opérations sensibles
  Future<void> _reAuthenticateUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Demander à l'utilisateur de saisir son mot de passe
    String password = await _showPasswordDialog();
    if (password.isEmpty) {
      throw FirebaseAuthException(
          code: 'invalid-password', message: 'Mot de passe requis');
    }

    // Créer les identifiants pour la réauthentification
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    // Réauthentifier
    await user.reauthenticateWithCredential(credential);
  }

  // Supprimer les données de l'utilisateur dans Firestore
  Future<void> _deleteUserData(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Suppression d'autres collections liées (si nécessaire)
      // Exemple : supprimer les commandes de l'utilisateur
      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();
      for (var doc in ordersSnapshot.docs) {
        await doc.reference.delete();
      }

      print("Données utilisateur supprimées avec succès.");
    } catch (e) {
      print("Erreur lors de la suppression des données Firestore : $e");
      rethrow;
    }
  }

  // Afficher une boîte de dialogue de confirmation
  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmation de suppression'),
            content: const Text(
              'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.',
            ),
            actions: [
              TextButton(
                child: const Text('Annuler'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                child: const Text('Supprimer'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Afficher une boîte de dialogue pour demander le mot de passe
  Future<String> _showPasswordDialog() async {
    String password = '';
    return await showDialog<String>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Vérification du mot de passe'),
              content: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Entrez votre mot de passe'),
                onChanged: (value) => password = value,
              ),
              actions: [
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.of(context).pop(''),
                ),
                ElevatedButton(
                  child: const Text('Confirmer'),
                  onPressed: () => Navigator.of(context).pop(password),
                ),
              ],
            );
          },
        ) ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: Text('Supprimer mon compte'),
      onPressed: deleteUser,
    );
  }
}
