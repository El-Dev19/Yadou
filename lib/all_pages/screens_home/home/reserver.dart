import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/data.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Reserver extends StatefulWidget {
  const Reserver({super.key});

  @override
  State<Reserver> createState() => _ReserverState();
}

class _ReserverState extends State<Reserver> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint("Notification ouverte : ${response.payload}");
      },
    );
  }

  Future<void> _submitReservation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Conversion de la date de réservation en Timestamp
        Timestamp? reservationTimestamp =
            _parseDateToTimestamp(_dateController.text);

        if (reservationTimestamp == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('La date de réservation est invalide.'),
            ),
          );
          setState(() {
            _isSubmitting = false;
          });
          return;
        }

        // Données de réservation
        final reservationData = {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'reservation_date':
              reservationTimestamp, // Date convertie en Timestamp
          'created_at': Timestamp.now(), // Date actuelle en Timestamp
          'siteName': _siteController.text,
        };

        // Enregistrer les données dans Firestore
        await FirebaseFirestore.instance
            .collection('reservations')
            .add(reservationData);

        // Afficher une notification
        await NotificationService.showNotification(
          title: 'Réservation Confirmée',
          body:
              'Votre réservation pour le site est confirmée, ${_nameController.text} !',
        );

        // Réinitialiser le formulaire
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Réservation effectuée avec succès !')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la réservation : ${e.toString()}'),
          ),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

// Fonction pour convertir une chaîne en Timestamp
  Timestamp? _parseDateToTimestamp(String dateText) {
    try {
      // Format attendu : "jour/mois/année"
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");
      DateTime parsedDate = dateFormat.parse(dateText);
      return Timestamp.fromDate(parsedDate); // Conversion en Timestamp
    } catch (e) {
      print("Erreur lors de la conversion de la date : $e");
      return null; // Retourne null si la conversion échoue
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservation'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Formulaire de réservation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Champ : Nom
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Votre Nom',
                  hintText: 'Entrez votre nom',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _siteController,
                decoration: const InputDecoration(
                  labelText: 'Site/Service/autres',
                  hintText: 'Entrez le nom du site ou service',
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez Le nom du site ou service.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Champ : Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Entrez votre adresse e-mail',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre adresse e-mail.';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un e-mail valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Champ : Téléphone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  hintText: 'Entrez votre numéro de téléphone',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro de téléphone.';
                  } else if (!RegExp(r'^\d{8,15}$').hasMatch(value)) {
                    return 'Veuillez entrer un numéro valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Champ : Date de réservation
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date de réservation',
                  hintText: 'Choisissez une date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _dateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez choisir une date.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Bouton de soumission
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReservation,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Réserver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
