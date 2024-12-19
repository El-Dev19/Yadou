import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchSitesTouristiques extends StatefulWidget {
  const SearchSitesTouristiques({super.key});

  @override
  State<SearchSitesTouristiques> createState() => _SearchSitesTouristiquesState();
}

class _SearchSitesTouristiquesState extends State<SearchSitesTouristiques> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  bool _isLoading = false;

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

  // Implémentation du debounce pour la recherche
  Future<void> _onSearchChanged() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
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
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _searchController,
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
      body: Column(
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
                  final site = _searchResults[index].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: site['imageUrl'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
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
          else if (_searchController.text.isNotEmpty)
            const Center(
              child: Text('Aucun résultat trouvé'),
            ),
        ],
      ),
    );
  }
}