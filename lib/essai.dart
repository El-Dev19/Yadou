import 'package:flutter/material.dart';

class MyTabBarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mon application'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.search), text: 'Recherche'),
              Tab(icon: Icon(Icons.view_agenda), text: 'Container'),
              Tab(icon: Icon(Icons.list), text: 'Liste'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Premier onglet avec barre de recherche
            SearchTab(),
            // Deuxième onglet avec container
            ContainerTab(),
            // Troisième onglet avec liste
            ListTab(),
          ],
        ),
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('Résultats de recherche apparaîtront ici'),
        ],
      ),
    );
  }
}

class ContainerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Container Personnalisé',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class ListTab extends StatelessWidget {
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.star),
          title: Text(items[index]),
          onTap: () {
            // Action lors du tap sur un élément de la liste
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Vous avez sélectionné ${items[index]}')),
            );
          },
        );
      },
    );
  }
}