import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AccountDeletionStatus {
  initial,
  requiresRecentLogin,
  processing,
  success,
  error
}

class AccountDeletionHandler {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  ValueNotifier<AccountDeletionStatus> status = 
      ValueNotifier(AccountDeletionStatus.initial);
  
  String errorMessage = '';

  Future<bool> deleteAccount() async {
    try {
      // Vérifier si un utilisateur est connecté
      User? user = _auth.currentUser;
      if (user == null) {
        status.value = AccountDeletionStatus.error;
        errorMessage = 'Aucun utilisateur connecté';
        return false;
      }

      // Commencer le processus de suppression
      status.value = AccountDeletionStatus.processing;

      // Supprimer le compte
      await user.delete();

      // Déconnexion après suppression
      await _auth.signOut();

      status.value = AccountDeletionStatus.success;
      return true;

    } on FirebaseAuthException catch (e) {
      // Gérer les erreurs spécifiques à Firebase
      switch (e.code) {
        case 'requires-recent-login':
          status.value = AccountDeletionStatus.requiresRecentLogin;
          errorMessage = 'Veuillez vous reconnecter pour supprimer votre compte';
          break;
        case 'user-not-found':
          status.value = AccountDeletionStatus.error;
          errorMessage = 'Utilisateur non trouvé';
          break;
        default:
          status.value = AccountDeletionStatus.error;
          errorMessage = 'Erreur lors de la suppression du compte';
      }
      return false;

    } catch (e) {
      // Gérer les erreurs génériques
      status.value = AccountDeletionStatus.error;
      errorMessage = 'Une erreur inattendue est survenue';
      return false;
    }
  }

  // Méthode pour réauthentifier l'utilisateur
  Future<bool> reAuthenticateAndDelete(String email, String password) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        status.value = AccountDeletionStatus.error;
        errorMessage = 'Aucun utilisateur connecté';
        return false;
      }

      // Créer les identifiants
      AuthCredential credential = EmailAuthProvider.credential(
        email: email, 
        password: password
      );

      // Réauthentification
      await user.reauthenticateWithCredential(credential);

      // Supprimer le compte après réauthentification
      return await deleteAccount();

    } on FirebaseAuthException catch (e) {
      status.value = AccountDeletionStatus.error;
      
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Mot de passe incorrect';
          break;
        case 'invalid-credential':
          errorMessage = 'Identifiants invalides';
          break;
        default:
          errorMessage = 'Erreur de réauthentification';
      }
      return false;
    } catch (e) {
      status.value = AccountDeletionStatus.error;
      errorMessage = 'Une erreur inattendue est survenue';
      return false;
    }
  }

  // Réinitialiser l'état
  void reset() {
    status.value = AccountDeletionStatus.initial;
    errorMessage = '';
  }
}