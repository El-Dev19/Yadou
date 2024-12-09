// Page des favoris (à implémenter)
import 'package:flutter/material.dart';
import 'package:myapp/data/data.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Sites> get favoriteSites {
    return sitesTouristiques.where((site) => site.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
      ),
      body: favoriteSites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Aucun site en favoris',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteSites.length,
              itemBuilder: (context, index) {
                final site = favoriteSites[index];
                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(site.imageUrls[0]),
                      // child: site.imageUrls.length > 1
                      //     ? null
                      //     : Image.network(
                      //         site.imageUrls[index],
                      //         width: 100,
                      //         height: 100,
                      //         fit: BoxFit.cover,
                      //       ),
                    ),
                    title: Text(site.name),
                    subtitle: Text(site.lieu),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.blue.shade500),
                      onPressed: () {
                        setState(() {
                          site.isFavorite = false;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
