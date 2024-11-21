import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/all_pages/utils.dart';

class SitesTouristiques extends StatelessWidget {
  const SitesTouristiques({super.key});

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
                    )),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slide d'images
            AnimatedCarousel(),
            // Titre de la section
            Row(
              children: [
                // Ecriture Most Visited
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Populaires',
                    style: GoogleFonts.inter(fontSize: 19, color: Colors.black),
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
                      style:
                          TextStyle(fontSize: 16, color: Colors.blue.shade500),
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
                    style: TextStyle(fontSize: 16, color: Colors.blue.shade500),
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
