import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/all_pages/utils.dart';
import 'package:myapp/data/data.dart';
// import 'package:myapp/pages/utils.dart';

class SitesPopulaires extends StatefulWidget {
  const SitesPopulaires({super.key});

  @override
  State<SitesPopulaires> createState() => _SitesPopulairesState();
}

class _SitesPopulairesState extends State<SitesPopulaires> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sitesTouristiques
            .map(
              (site) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(site: site),
                    ),
                  );
                },
                child: Container(
                  width: 180,
                  height: 150,
                  margin: const EdgeInsets.all(10),
                  // padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Stack(
                    children: [
                      Container(
                        height: 210,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(site.imageUrls[0]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Positioned(
                        // Debut Bouton
                        top: 10,
                        right: 10,
                        child: FavoriteButton(site: site),
                      ), // Bootuon favorite
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: 200,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    site.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  // SizedBox(height: ,),
                                  Text(
                                    site.lieu,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// Page de détails d'un site touristique
class DetailPage extends StatelessWidget {
  final Sites site;

  const DetailPage({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(site.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimeImages(
              site: site,
            ),
            // Container(
            //   height: 200,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: site.imageUrls.length,
            //     itemBuilder: (context, index) {
            //       return Container(
            //         width: MediaQuery.of(context).size.width,
            //         child: Image.network(
            //           site.imageUrls[index],
            //           fit: BoxFit.cover,
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    child: ListView(
                      children: [
                        Text(
                          site.name,
                          style: GoogleFonts.inter(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(site.description,
                            style: GoogleFonts.inter(fontSize: 16)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment,
                    children: [
                      Material(
                        elevation: 5,
                        // borderRadius: BorderRadius.circular(10),
                        child: CircleAvatar(
                          child: FavoriteButton(site: site),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // const Spacer(),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade500,
                            foregroundColor: Colors.white,
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Reserver(),
                              ),
                            );
                          },
                          child: const Text("Book Now"),
                        ),
                      ), // Boutton De Reservation
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimeImages extends StatefulWidget {
  final Sites site;

  // Le site spécifique est passé au widget via son constructeur.
  const AnimeImages({super.key, required this.site});

  @override
  State<AnimeImages> createState() => _AnimeImagesState();
}

class _AnimeImagesState extends State<AnimeImages> {
  int currentindex = 0;
  final PageController _pageController = PageController();
  late dynamic siteUrls;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    siteUrls = widget.site.imageUrls;
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (currentindex != next) {
        setState(() {
          currentindex = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: PageView.builder(
              controller: _pageController,
              itemCount: siteUrls.length,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(siteUrls[0]),
                      fit: BoxFit.fill,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                );
              }),
        ),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            siteUrls.length,
            (index) => buildIndicator(index),
          ),
        ),
      ],
    );
  }

  Widget buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      width: currentindex == index ? 30 : 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: currentindex == index ? Colors.blue.shade500 : Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// LEs Details De SeeAll/ VoirPlus
class MoreMostVisited extends StatelessWidget {
  const MoreMostVisited({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Populaires',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: sitesTouristiques
              .map(
                (site) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(site: site),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, left: 16),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                              child: Image.network(
                                site.imageUrls[0],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    site.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(site.lieu),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.blue.shade500),
                                          Text(site.etoile),
                                        ],
                                      ),
                                      Text(
                                        site.price,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Reserver(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade500,
                                          ),
                                          child: Text(
                                            'Book Now',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              )
              .toList(),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.site});
  final Sites site;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _toggleFavorite() async {
    try {
      // Vérifier si l'utilisateur est connecté
      User? user = _auth.currentUser;
      if (user == null) {
        // Gérer le cas où l'utilisateur n'est pas connecté
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez vous connecter pour ajouter aux favoris'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Référence à la collection des favoris de l'utilisateur
      DocumentReference userFavoritesRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.site.name);

      // Inverser l'état des favoris
      setState(() {
        widget.site.isFavorite = !widget.site.isFavorite;
      });

      if (widget.site.isFavorite) {
        // Ajouter aux favoris
        await userFavoritesRef.set({
          'name': widget.site.name,
          'description': widget.site.description,
          'price': widget.site.price,
          'etoile': widget.site.etoile,
          'lieu': widget.site.lieu,
          'imageUrls': widget.site.imageUrls,
          // 'addedAt': FieldValue.serverTimestamp(),
        });

        // Afficher un message de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.site.name} ajouté aux favoris'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // Supprimer des favoris
        await userFavoritesRef.delete();

        // Afficher un message de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.site.name} retiré des favoris'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Gérer les erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.site.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.blue.shade500,
        ),
      ),
    );
  }
}
