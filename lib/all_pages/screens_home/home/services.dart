import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/all_pages/screens_home/home/reserver.dart';
import 'package:myapp/data/class/bus_service.dart';
import 'package:myapp/data/class/flight_services.dart';
import 'package:myapp/data/class/hotel_service.dart';
import 'package:myapp/data/class/train_service.dart';
import '../../../data/class/list_services.dart';

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
                      const Spacer(),
                      Text(
                        servicesAll[index].name,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
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
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FlightPage(),
            HotelPage(),
            TrainPage(),
            BusPage(),
            // Text('Boat'),
          ],
        ),
      ),
    );
  }
}

class FlightPage extends StatelessWidget {
  // final Flight flight;
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
          FlightCard(),
        ],
      ),
    );
  }
}

// LEs Details De SeeAll/ VoirPlus
class FlightCard extends StatelessWidget {
  const FlightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: flightAll
          .map(
            (Flight) => GestureDetector(
                onTap: () {},
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
                            Flight.imageUrls[0],
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
                                Flight.name,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(Flight.lieu),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.blue.shade500),
                                      Text(Flight.etoile),
                                    ],
                                  ),
                                  Text(
                                    Flight.price,
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
                                        backgroundColor: Colors.blue.shade500,
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
    );
  }
}

class HotelPage extends StatelessWidget {
  // final Flight flight;
  const HotelPage({super.key});

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
          HotelCard(),
        ],
      ),
    );
  }
}

class HotelCard extends StatelessWidget {
  const HotelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: hoteltAll
          .map(
            (Hotels) => GestureDetector(
                onTap: () {},
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
                            Hotels.imageUrls[0],
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
                                Hotels.name,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(Hotels.lieu),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.blue.shade500),
                                      Text(Hotels.etoile),
                                    ],
                                  ),
                                  Text(
                                    Hotels.price,
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
                                        backgroundColor: Colors.blue.shade500,
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
    );
  }
}

class TrainPage extends StatelessWidget {
  // final Flight flight;
  const TrainPage({super.key});

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
          TrainCard()
        ],
      ),
    );
  }
}

class TrainCard extends StatelessWidget {
  const TrainCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: traintAll
          .map(
            (Trains) => GestureDetector(
                onTap: () {},
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
                            Trains.imageUrls[0],
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
                                Trains.name,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(Trains.lieu),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.blue.shade500),
                                      Text(Trains.etoile),
                                    ],
                                  ),
                                  Text(
                                    Trains.price,
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
                                        backgroundColor: Colors.blue.shade500,
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
    );
  }
}

class BusPage extends StatelessWidget {
  // final Flight flight;
  const BusPage({super.key});

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
          BusCard(),
        ],
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  const BusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: busAll
          .map(
            (BusService) => GestureDetector(
                onTap: () {},
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
                            BusService.imageUrls[0],
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
                                BusService.name,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(BusService.lieu),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.blue.shade500),
                                      Text(BusService.etoile),
                                    ],
                                  ),
                                  Text(
                                    BusService.price,
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
                                        backgroundColor: Colors.blue.shade500,
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
    );
  }
}
