import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/class.dart/list_services.dart';

class ServicesPro extends StatelessWidget {
  // final Services services;
  const ServicesPro({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: servicesAll.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(servicesAll[index].icone.icon, color: Colors.blue),
                        Spacer(),
                        Text(
                          servicesAll[index].name,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MoreServices extends StatelessWidget {
  const MoreServices({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Services',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.flight_class_rounded,
                  color: Colors.blue.shade500,
                ),
                text: 'Flight',
              ),
              Tab(
                icon: Icon(
                  Icons.hotel_class_rounded,
                  color: Colors.blue.shade500,
                ),
                text: 'Hotel',
              ),
              Tab(
                icon: Icon(
                  Icons.train_rounded,
                  color: Colors.blue.shade500,
                ),
                text: 'Train',
              ),
              Tab(
                icon: Icon(
                  Icons.bus_alert_rounded,
                  color: Colors.blue.shade500,
                ),
                text: 'Bus',
              ),
              Tab(
                icon: Icon(
                  Icons.directions_boat_rounded,
                  color: Colors.blue.shade500,
                ),
                text: 'Boat',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FlightPage(),
            Text('Hotel'),
            Text('Train'),
            Text('Bus'),
            Text('Boat'),
          ],
        ),
      ),
    );
  }
}

class FlightPage extends StatelessWidget {
  const FlightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: Container(
              height: 50,
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
            ),
          ),
        ],
      ),
    );
  }
}
