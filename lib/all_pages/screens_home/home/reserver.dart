import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Reserver extends StatefulWidget {
  const Reserver({super.key});

  @override
  State<Reserver> createState() => _ReserverState();
}

class _ReserverState extends State<Reserver> {
  void showReservationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        String name = '';
        String email = '';
        String phone = '';
        String countryCode = '+224'; // Valeur par défaut

        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Confirmer la Réservation',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Entrez votre nom'
                          : null,
                      onSaved: (value) => name = value!,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || !value.contains('@')
                              ? 'Email invalide'
                              : null,
                      onSaved: (value) => email = value!,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: countryCode,
                            decoration: const InputDecoration(
                              labelText: 'Code',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              '+1',
                              '+33',
                              '+224',
                              '+91',
                              '+237'
                            ] // Ajoute les codes nécessaires
                                .map((code) => DropdownMenuItem(
                                      value: code,
                                      child: Text(code),
                                    ))
                                .toList(),
                            onChanged: (value) => countryCode = value!,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Téléphone',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Entrez votre numéro'
                                : null,
                            onSaved: (value) => phone = value!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Appelle la fonction pour envoyer l'email et la notification
                          confirmReservation(
                              context, name, email, '$countryCode' '$phone');
                          // confirmReservation(name as BuildContext, email,
                          //     '$countryCode $phone');
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Confirmer la Réservation'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void confirmReservation(
      BuildContext context, String name, String email, String phone) async {
    final sendEmail =
        FirebaseFunctions.instance.httpsCallable('sendReservationEmail');

    try {
      await sendEmail({
        'name': name,
        'email': email,
        'phone': phone,
      });

      // Message de succès
      print('Email envoyé avec succès !');
      _showSuccessDialog(context, 'Réservation Confirmée',
          'Votre réservation a été confirmée et un email a été envoyé.');
    } catch (e) {
      // Gestion des erreurs
      print('Erreur lors de l\'envoi de l\'email : $e');
      _showErrorDialog(context, 'Erreur',
          'Une erreur s\'est produite lors de l\'envoi de l\'email.');
    }
  }

  void sendNotification(BuildContext context, String token, String name) async {
    final sendNotif =
        FirebaseFunctions.instance.httpsCallable('sendNotification');

    try {
      await sendNotif({
        'token': token,
        'name': name,
      });

      // Message de succès
      print('Notification envoyée avec succès !');
      _showSuccessDialog(context, 'Notification Envoyée',
          'Votre notification a été envoyée avec succès.');
    } catch (e) {
      // Gestion des erreurs
      print('Erreur lors de l\'envoi de la notification : $e');
      _showErrorDialog(context, 'Erreur',
          'Une erreur s\'est produite lors de l\'envoi de la notification.');
    }
  }

  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 1.3,
        decoration: BoxDecoration(
          color: Colors.blue.shade500,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: () => showReservationSheet(context),
          child: Center(
            child: Text(
              'Réserver Maintenant',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
