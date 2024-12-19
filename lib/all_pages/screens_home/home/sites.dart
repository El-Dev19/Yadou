import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/all_pages/utils.dart';

class SitesTouristiques extends StatefulWidget {
  const SitesTouristiques({super.key});

  @override
  State<SitesTouristiques> createState() => _SitesTouristiquesState();
}

class _SitesTouristiquesState extends State<SitesTouristiques> {
  // Ajout des variables nécessaires pour la recherche
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  bool _isLoading = false;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fonction de recherche
  Future<void> _onSearchChanged() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showResults = true;
    });

    try {
      final searchQuery = _searchController.text.toLowerCase();
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sites_touristiques')
          .where('nom_searchable', isGreaterThanOrEqualTo: searchQuery)
          .where('nom_searchable', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .limit(10)
          .get();

      setState(() {
        _searchResults = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur de recherche: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          flexibleSpace: Stack(
            children: [
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _searchController, // Ajout du contrôleur
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.blueGrey),
                        hintText: 'Rechercher un site touristique',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.blue.shade500,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _showResults = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          leading: DrawerButton(
            color: Colors.blue.shade500,
          ),
          actions: [
            IconButton(
              color: Colors.blue.shade500,
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: _showResults
          ? Column(
              children: [
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (_searchResults.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final site = _searchResults[index].data()
                            as Map<String, dynamic>;
                        return ListTile(
                          leading: site['imageUrl'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    site['imageUrl'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.place),
                          title: Text(site['nom'] ?? ''),
                          subtitle: Text(site['description'] ?? ''),
                          onTap: () {
                            // Navigation vers la page de détails
                          },
                        );
                      },
                    ),
                  )
                else
                  const Center(
                    child: Text('Aucun résultat trouvé'),
                  ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slide d'images
                  const AnimatedCarousel(),
                  // Titre de la section
                  Row(
                    children: [
                      // Ecriture Most Visited
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Populaires',
                          style: GoogleFonts.inter(
                              fontSize: 19, color: Colors.black),
                        ),
                      ),
                      const Spacer(),
                      // See All de Most Visited
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MoreMostVisited(),
                              ),
                            );
                          },
                          child: Text(
                            'Voir Plus',
                            style: TextStyle(
                                fontSize: 16, color: Colors.blue.shade500),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Section Sites les plus visites MOst Visited
                  const SitesPopulaires(),
                  // Encadrement

                  // Sectiion pour les services
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(children: [
                      const Text(
                        'Services',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MoreServices(),
                            ),
                          );
                        },
                        child: Text(
                          'Voir Plus',
                          style: TextStyle(
                              fontSize: 16, color: Colors.blue.shade500),
                        ),
                      ),
                    ]),
                  ),

                  ServicesPro(),
                ],
              ),
            ),
    );
  }
}
