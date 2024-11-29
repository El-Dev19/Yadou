import 'package:flutter/material.dart';
import '../forms.dart';

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

  bool _isLogin = true;
  bool _isLoading = false; // Mode actuel (connexion ou inscription)

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
      signIn(email: email, password: password);
      // signIn(email: email, password: password);
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
                  decoration: const InputDecoration(labelText: 'Nom complet'),
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
                decoration: const InputDecoration(labelText: 'Adresse email'),
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
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // ElevatedButton(
              //   onPressed: _submitForm,
              //   child: Text(_isLogin ? 'Se connecter' : "S'inscrire"),
              // ),
              // TextButton(
              //   onPressed: _toggleFormMode,
              //   child: Text(
              //     _isLogin
              //         ? "Pas encore de compte ? S'inscrire"
              //         : 'Déjà un compte ? Se connecter',
              //   ),
              // ),
              _isLoading
                  ? const CircularProgressIndicator()
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


