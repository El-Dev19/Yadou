import 'package:firebase_auth/firebase_auth.dart';

// Inscription d'un utilisateur
Future<void> signUp({required String email, required String password}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print("Utilisateur inscrit : ${userCredential.user?.email}");
  } catch (e) {
    print("Erreur d'inscription : $e");
  }
}

//Connexion d'un utilisateur
Future<void> signIn({required String email, required String password}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print("Utilisateur connecté : ${userCredential.user?.email}");
  } catch (e) {
    print("Erreur de connexion : $e");
  }
}


// Deconnexion d'un utilisateur
Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    print("Utilisateur déconnecté");
  } catch (e) {
    print("Erreur de déconnexion : $e");
  }
}

// Reinitialisation du mot de passe
// Envoyez un email pour permettre à l'utilisateur de réinitialiser son mot de passe.
Future<void> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    print("Email de réinitialisation envoyé à $email");
  } catch (e) {
    print("Erreur de réinitialisation : $e");
  }
}

/* Mise A jour des informations Utilisateurs */

// Mise a jour de l'email
Future<void> updateEmail(String newEmail) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.updateEmail(newEmail);
    print("Email mis à jour : $newEmail");
  } catch (e) {
    print("Erreur de mise à jour de l'email : $e");
  }
}

// Mise a jour du mot de passe
Future<void> updatePassword(String newPassword) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.updatePassword(newPassword);
    print("Mot de passe mis à jour");
  } catch (e) {
    print("Erreur de mise à jour du mot de passe : $e");
  }
}

// Mise a jour du profil (nom, photo)
Future<void> updateProfile(String displayName, String photoURL) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.updateDisplayName(displayName);
    await user?.updatePhotoURL(photoURL);
    print("Profil mis à jour : $displayName, $photoURL");
  } catch (e) {
    print("Erreur de mise à jour du profil : $e");
  }
}

// Suppression d'un utilisateur 
//Supprimez l'utilisateur actuel avec delete.
Future<void> deleteUser() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.delete();
    print("Utilisateur supprimé");
  } catch (e) {
    print("Erreur de suppression de l'utilisateur : $e");
  }
}

// Recuperation des infoinformations Utilisateurs
/* Récupérez les informations sur l'utilisateur connecté avec 
   FirebaseAuth.instance.currentUser.*/
void getUserDetails() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print("ID : ${user.uid}");
    print("Email : ${user.email}");
    print("Nom : ${user.displayName}");
    print("Photo : ${user.photoURL}");
  } else {
    print("Aucun utilisateur connecté");
  }
}

// Gestion des erreurs Courantes
/* Les erreurs retournées par Firebase Auth incluent des codes spécifiques. 
   Vous pouvez les gérer pour offrir des retours utilisateurs plus clairs.*/
Future<void> signInTry(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("Connexion réussie !");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print("Aucun utilisateur trouvé pour cet email.");
    } else if (e.code == 'wrong-password') {
      print("Mot de passe incorrect.");
    } else {
      print("Erreur : ${e.message}");
    }
  }
}





