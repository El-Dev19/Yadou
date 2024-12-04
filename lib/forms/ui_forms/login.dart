// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/forms/forms.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  // Champs contrôleurs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscureCurrentPassword = true;
  bool _isLogin = true;
  bool _isLoading = false; // Mode actuel (connexion ou inscription)

// Gestion des erreurs Courantes
/* Les erreurs retournées par Firebase Auth incluent des codes spécifiques. 
   Vous pouvez les gérer pour offrir des retours utilisateurs plus clairs.*/

  void signInTry({required String email, required String password}) async {
    try {
      // Validation préalable des entrées
      if (email.isEmpty || password.isEmpty) {
        _showSnackbar("Veuillez saisir un email et un mot de passe");
        return;
      }

      // Mise à jour de l'état de chargement
      setState(() => _isLoading = true);

      // Tentative de connexion
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Connexion réussie
      _showSnackbar("Connexion réussie");
      // Navigation ou action post-connexion
      // Navigator.pushReplacement(context, MaterialPageRoute(...));
    } on FirebaseAuthException catch (e) {
      // Gestion détaillée des exceptions Firebase
      switch (e.code) {
        case 'user-not-found':
          _showSnackbar("Aucun compte n'existe avec cet email");
          break;
        case 'wrong-password':
          _showSnackbar("Email ou Mot de Passe incorrect");
          break;
        case 'invalid-email':
          _showSnackbar("Format d'email invalide");
          break;
        case 'user-disabled':
          _showSnackbar("Ce compte a été désactivé");
          break;
        case 'too-many-requests':
          _showSnackbar("Trop de tentatives. Réessayez plus tard");
          break;
        default:
          // Logging de l'erreur pour le développement
          print('Erreur de connexion non gérée : ${e.code}');
          _showSnackbar("Votre Email Ou Mot de Passe est invalide !");
      }
    } on Exception catch (e) {
      // Gestion des exceptions génériques
      _showSnackbar("Une erreur inattendue est survenue");
      print('Erreur inattendue : $e');
    } finally {
      // Réinitialisation de l'état de chargement
      setState(() => _isLoading = false);
    }
  }

  void signUp({required String email, required String password}) async {
    // Validation préalable
    if (!_validateInputs(email, password)) return;

    setState(() => _isLoading = true);

    try {
      // Vérification supplémentaire de l'email
      if (!_isValidEmailFormat(email)) {
        _showSnackbar('Format d\'email invalide');
        return;
      }

      // Vérification de la force du mot de passe
      if (!_isStrongPassword(password)) {
        _showSnackbar(
            'Mot de passe trop faible. Il doit contenir au moins 8 caractères, une majuscule, un chiffre et un caractère spécial.');
        return;
      }

      // Tentative d'inscription
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // Langue de l'email envoyé
      await FirebaseAuth.instance.setLanguageCode("fr");
      // Envoi éventuel d'un email de vérification
      await credential.user?.sendEmailVerification();

      // Création du profil utilisateur dans Firestore (optionnel)
      await _createUserProfile(credential.user);
      // Feedback utilisateur
      _showSnackbar('Votre compte a été créé. Veuillez vérifier votre email.');
      // Navigation ou action post-inscription
      // Navigator.pushReplacement(context, MaterialPageRoute(...));
      // Rediriger vers l'écran de vérification d'email
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => EmailVerificationScreen(user: credential.user!)
      //   )
      // );
    } on FirebaseAuthException catch (e) {
      // Gestion détaillée des exceptions Firebase
      switch (e.code) {
        case 'weak-password':
          _showSnackbar('Le mot de passe est trop faible');
          break;
        case 'email-already-in-use':
          _showSnackbar('Un compte existe déjà avec cet email');
          break;
        case 'invalid-email':
          _showSnackbar('Format d\'email invalide');
          break;
        case 'operation-not-allowed':
          _showSnackbar('Inscription temporairement désactivée');
          break;
        default:
          _showSnackbar('Erreur d\'inscription. Réessayez.');
          print('Erreur Firebase non gérée : ${e.code}');
      }
    } on Exception catch (e) {
      // Gestion des exceptions génériques
      _showSnackbar('Une erreur inattendue est survenue');
      print('Erreur inattendue lors de l\'inscription : $e');
    } finally {
      // Réinitialisation de l'état de chargement
      setState(() => _isLoading = false);
    }
  }

// Méthodes de validation supplémentaires
  bool _validateInputs(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      _showSnackbar('Veuillez remplir tous les champs');
      return false;
    }
    return true;
  }

  bool _isValidEmailFormat(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password);
  }

  Future<void> _createUserProfile(User? user) async {
    if (user != null) {
      try {
        // Exemple avec Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          // Autres informations du profil
        });
      } catch (e) {
        print('Erreur lors de la création du profil utilisateur : $e');
      }
    }
  }

  void _toggleFormMode() {
    setState(() {
      _isLogin = !_isLogin; // Basculer entre inscription et connexion
    });
  }

  void _showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 5),
    ));
  }

  void _submitForm() {
    // if (_formKey.currentState!.validate()) {
    //   if (_isLogin) {
    //     // ignore: avoid_print
    //     print("Connexion...");
    //     print("Email: ${_emailController.text}");
    //     print("Mot de passe: ${_passwordController.text}");
    //   } else {
    //     print("Inscription...");
    //     print("Nom: ${_nameController.text}");
    //     print("Email: ${_emailController.text}");
    //     print("Mot de passe: ${_passwordController.text}");
    //   }
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("email or password  is empty");
      return;
    }

    // if (_selectedImage == null && !_isLogin) {
    //   _showSnackbar("Please pick an image");
    //   return;
    // }

    if (_isLogin) {
      signInTry(email: email, password: password);
      return;
    }
    signUp(email: email, password: password);

    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(_isLogin ? 'Connexion réussie !' : 'Inscription réussie !')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Connexion' : 'Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (!_isLogin)
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom complet',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (!_isLogin && (value == null || value.isEmpty)) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Adresse email',
                  prefixIcon: const Icon(Icons.email_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer une adresse email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock_clock_rounded),
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
              ),
              // const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PasswordResetScreen(),
                          ),
                        );
                      },
                      child: const Text("Mot de passe oublié"))
                ],
              ),
              _isLoading
                  ? Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(child: CircularProgressIndicator()))
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Text(_isLogin ? 'SignIn' : 'Signup'),
                    ),
              TextButton(
                onPressed: () {
                  _toggleFormMode();
                },
                child: Text(_isLogin
                    ? 'Create an account'
                    : 'I already have an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
