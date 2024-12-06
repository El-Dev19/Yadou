import 'package:flutter/material.dart';
import 'package:myapp/data/emails/emails.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final EmailActionHandler _emailHandler = EmailActionHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Réinitialisation de mot de passe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<EmailActionStatus>(
              valueListenable: _emailHandler.status,
              builder: (context, status, child) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: status == EmailActionStatus.sending
                          ? null
                          : () async {
                              bool success =
                                  await _emailHandler.sendPasswordResetEmail(
                                      _emailController.text.trim());

                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Email de réinitialisation envoyé')));
                              }
                            },
                      child: const Text('Réinitialiser le mot de passe'),
                    ),
                    if (status == EmailActionStatus.sending)
                      const CircularProgressIndicator(),
                    if (status == EmailActionStatus.error)
                      Text(
                        _emailHandler.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
