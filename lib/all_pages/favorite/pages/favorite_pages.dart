// Page des favoris (à implémenter)
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/data.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
        body: StreamBuilder(
            stream:
                // demo Collections
                FirebaseFirestore.instance.collection("favorite").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // List<dynamic> favorite = [];
              // snapshots.data!.docs.forEach((element) {
              //   favorite.add(element.data());
              // });
              // for (var element in snapshots.data!.docs) {
              //   favorite.add(element.data());
              // }
              return favoriteSites.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border,
                              size: 100, color: Colors.grey),
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
                            ),
                            title: Text(site.name),
                            subtitle: Text(site.lieu),
                            trailing: IconButton(
                              icon: Icon(Icons.favorite,
                                  color: Colors.blue.shade500),
                              onPressed: () {
                                setState(() {
                                  site.isFavorite = false;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
            }));
  }
}
