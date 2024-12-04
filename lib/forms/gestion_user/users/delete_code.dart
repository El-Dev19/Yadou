import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/forms/forms.dart';

class DeleteUser extends StatefulWidget {
  const DeleteUser({super.key});

  @override
  _DeleteUserState createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  // Méthode pour afficher un message temporaire
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Méthode de suppression de compte
  Future<void> deleteUser() async {
    try {
      // Demander confirmation à l'utilisateur
      bool confirmDelete = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Confirmation de suppression'),
              content: Text(
                  'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.'),
              actions: [
                TextButton(
                  child: Text('Annuler'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  child: Text('Supprimer'),
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ) ??
          false;

      // Si l'utilisateur n'a pas confirmé, on arrête là
      if (!confirmDelete) return;

      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _showSnackbar("Aucun utilisateur connecté");
        return;
      }

      // Réauthentification
      await _reAuthenticateUser();

      // Suppression des données utilisateur dans Firestore
      await _deleteUserData(user.uid);

      // Suppression du compte Firebase
      await user.delete();

      // Déconnexion
      await FirebaseAuth.instance.signOut();

      // Redirection vers l'écran d'authentification
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthForm()),
          (route) => false);
      // Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);

      _showSnackbar("Compte supprimé avec succès");
    } on FirebaseAuthException catch (e) {
      // Gestion des exceptions spécifiques à Firebase
      switch (e.code) {
        case 'requires-recent-login':
          _showSnackbar("Reconnectez-vous pour supprimer le compte");
          break;
        case 'user-not-found':
          _showSnackbar("Utilisateur non trouvé");
          break;
        default:
          _showSnackbar("Erreur lors de la suppression du compte");
      }
      print("Erreur Firebase lors de la suppression : ${e.code}");
    } catch (e) {
      // Gestion des erreurs génériques
      _showSnackbar("Une erreur est survenue");
      print("Erreur de suppression de l'utilisateur : $e");
    }
  }

  // Méthode de réauthentification
  Future<void> _reAuthenticateUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Demander à l'utilisateur de se reconnecter
      AuthCredential credential = await _demanderIdentifiants();

      // Réauthentification
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      print("Erreur de réauthentification : $e");
      rethrow;
    }
  }

  // Méthode pour obtenir les identifiants de l'utilisateur
  Future<AuthCredential> _demanderIdentifiants() async {
    return EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: await _montrerBoiteDialogueMotDePasse());
  }

  // Méthode de suppression des données utilisateur
  Future<void> _deleteUserData(String userId) async {
    try {
      // Suppression des données de l'utilisateur dans Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Vous pouvez ajouter ici la suppression d'autres collections liées à l'utilisateur
    } catch (e) {
      print("Erreur lors de la suppression des données utilisateur : $e");
      rethrow;
    }
  }

  // Méthode pour afficher une boîte de dialogue de mot de passe
  Future<String> _montrerBoiteDialogueMotDePasse() async {
    return await showDialog(
            context: context,
            builder: (context) {
              String motDePasse = '';
              return AlertDialog(
                title: Text('Confirmation'),
                content: TextField(
                  obscureText: true,
                  decoration:
                      InputDecoration(hintText: 'Entrez votre mot de passe'),
                  onChanged: (value) => motDePasse = value,
                ),
                actions: [
                  TextButton(
                    child: Text('Annuler'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    child: Text('Confirmer'),
                    onPressed: () => Navigator.of(context).pop(motDePasse),
                  ),
                ],
              );
            }) ??
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
