import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour récupérer les réservations
  Future<List<Map<String, dynamic>>> _fetchReservations() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('reservations').get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print("Erreur : $e");
      return [];
    }
  }

  // Fonction pour supprimer une réservation
  Future<void> _deleteReservation(String reservationId) async {
    try {
      await _firestore.collection('reservations').doc(reservationId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Réservation supprimée avec succès.")),
      );
      setState(() {}); // Rafraîchit la liste après suppression
    } catch (e) {
      print("Erreur lors de la suppression : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression : $e")),
      );
    }
  }

  // Fonction pour formater une date
  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Date inconnue';
    }
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy à HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Réservations"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur : ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Aucune réservation trouvée."),
            );
          }

          List<Map<String, dynamic>> reservations = snapshot.data!;
          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> reservation = reservations[index];

              String reservationId =
                  reservation['id']; // L'ID du document Firestore
              String siteName = reservation['siteName'] ?? 'Nom indisponible';
              Timestamp reservationDate = reservation['created_at'];
              String readableDate = formatDate(reservationDate);

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading:
                      const Icon(Icons.event_available, color: Colors.blue),
                  title: Text(
                    siteName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Réservé  le : $readableDate"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteReservation(reservationId);
                      } else if (value == 'details') {
                        _showDetailsDialog(context, reservation);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'details',
                        child: Text("Voir les détails"),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Supprimer"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fonction pour afficher les détails dans une boîte de dialogue
  void _showDetailsDialog(
      BuildContext context, Map<String, dynamic> reservation) {
    showDialog(
      context: context,
      builder: (context) {
        String siteName = reservation['siteName'] ?? 'Nom indisponible';
        Timestamp reservationDate = reservation['reservation_date'];
        String readableDate = formatDate(reservationDate);
        // String description =
        //     reservation['description'] ?? 'Pas de description disponible.';

        return AlertDialog(
          title: const Text("Détails de la réservation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nom du site : $siteName"),
              const SizedBox(height: 8),
              Text("Date réservée : $readableDate"),
              // const SizedBox(height: 8),
              // Text("Description : $description"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }
}
