import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum EmailActionStatus {
  initial,
  sending,
  success,
  error
}

class EmailActionHandler {
  ValueNotifier<EmailActionStatus> status = ValueNotifier(EmailActionStatus.initial);
  String errorMessage = '';

  // Méthode de réinitialisation de mot de passe
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      status.value = EmailActionStatus.sending;
      
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      status.value = EmailActionStatus.success;
      return true;
    } on FirebaseAuthException catch (e) {
      status.value = EmailActionStatus.error;
      
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Adresse email invalide';
          break;
        case 'user-not-found':
          errorMessage = 'Aucun utilisateur trouvé avec cet email';
          break;
        default:
          errorMessage = 'Erreur lors de l\'envoi de l\'email de réinitialisation';
      }
      
      return false;
    } catch (e) {
      status.value = EmailActionStatus.error;
      errorMessage = 'Une erreur inattendue est survenue';
      return false;
    }
  }

  // Méthode de vérification d'email
  Future<bool> sendEmailVerification() async {
    try {
      status.value = EmailActionStatus.sending;
      
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        status.value = EmailActionStatus.error;
        errorMessage = 'Aucun utilisateur connecté';
        return false;
      }

      await user.sendEmailVerification();
      
      status.value = EmailActionStatus.success;
      return true;
    } on FirebaseAuthException catch (e) {
      status.value = EmailActionStatus.error;
      
      switch (e.code) {
        case 'too-many-requests':
          errorMessage = 'Trop de demandes. Réessayez plus tard.';
          break;
        default:
          errorMessage = 'Erreur lors de l\'envoi de l\'email de vérification';
      }
      
      return false;
    } catch (e) {
      status.value = EmailActionStatus.error;
      errorMessage = 'Une erreur inattendue est survenue';
      return false;
    }
  }

  // Réinitialisation de l'état
  void reset() {
    status.value = EmailActionStatus.initial;
    errorMessage = '';
  }
}