import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:myapp/all_pages/utils.dart';

// Exemple d'utilisation dans un écran de changement de mot de passe
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscureCurrentPassword = true;
  bool _isObscureNewPassword = true;
  bool _isObscureConfirmPassword = true;

  Future<bool> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    try {
      // Récupérer l'utilisateur actuel
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Gérer le cas où aucun utilisateur n'est connecté
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Aucun utilisateur connecté')));
        return false;
      }

      // Étape cruciale : réauthentifier l'utilisateur
      // Ceci est nécessaire pour les changements de mot de passe récents
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: currentPassword);

      try {
        // Réauthentification
        await user.reauthenticateWithCredential(credential);
      } on FirebaseAuthException catch (reauthError) {
        // Gérer les erreurs de réauthentification
        String errorMessage = 'Erreur de réauthentification';
        switch (reauthError.code) {
          case 'wrong-password':
            errorMessage = 'Mot de passe actuel incorrect';
            break;
          case 'user-mismatch':
            errorMessage = 'Les identifiants ne correspondent pas';
            break;
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
        return false;
      }

      // Validation du nouveau mot de passe
      if (!_isStrongPassword(newPassword)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Le nouveau mot de passe est trop faible. '
                'Il doit contenir au moins 8 caractères, '
                'une majuscule, un chiffre et un caractère spécial.')));
        return false;
      }

      // Mise à jour du mot de passe
      await user.updatePassword(newPassword);

      // Feedback utilisateur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Mot de passe mis à jour avec succès'),
        backgroundColor: Colors.green,
      ));

      return true;
    } on FirebaseAuthException catch (e) {
      // Gestion des exceptions Firebase
      String errorMessage = 'Erreur de mise à jour du mot de passe';

      switch (e.code) {
        case 'requires-recent-login':
          errorMessage =
              'Veuillez vous reconnecter pour modifier le mot de passe';
          break;
        case 'weak-password':
          errorMessage = 'Le nouveau mot de passe est trop faible';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
      return false;
    } catch (e) {
      // Gestion des erreurs génériques
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur inattendue est survenue'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

// Méthode de validation du mot de passe (à intégrer dans votre classe)
  bool _isStrongPassword(String password) {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changer de mot de passe'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ mot de passe actuel
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe actuel',
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureCurrentPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscureCurrentPassword = !_isObscureCurrentPassword;
                      });
                    },
                  ),
                ),
                obscureText: _isObscureCurrentPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe actuel';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Champ nouveau mot de passe
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureNewPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscureNewPassword = !_isObscureNewPassword;
                      });
                    },
                  ),
                ),
                obscureText: _isObscureNewPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nouveau mot de passe';
                  }
                  if (!_isStrongPassword(value)) {
                    return 'Le mot de passe est trop faible';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Confirmation du nouveau mot de passe
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmer le nouveau mot de passe',
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirmPassword = !_isObscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _isObscureConfirmPassword,
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool success = await updatePassword(
                        currentPassword: _currentPasswordController.text,
                        newPassword: _newPasswordController.text);

                    if (success) {
                      // Optionnel : naviguer ou effacer les champs
                      _currentPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                    }
                  }
                },
                child: Text('Changer le mot de passe'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
