import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//import 'bus_detail_page.dart'; // A page to show details of the bus

class BusListPage extends StatelessWidget {
  static final List<Bus> buses = [
    Bus(
        id: '12345',
        startLocation: 'Merkato',
        destination: 'Gebriel',
        channelId: '2545299',
        apiKey: 'C9Q9Y9SR9WCTGQFH'),
    Bus(
        id: '67890',
        startLocation: 'Merkato',
        destination: 'Hospital',
        channelId: '2540299',
        apiKey: 'C9Q9Y9SR9WCTGQFH'),
    Bus(
        id: '54321',
        startLocation: 'Hospital',
        destination: 'Agip',
        channelId: '2541199',
        apiKey: 'C9Q9Y9SR9WCTGQFH'),
    Bus(
        id: '12045',
        startLocation: 'Merkato',
        destination: 'Gebriel',
        channelId: '2554524',
        apiKey: 'LY0LHQ2N8WEN5LQY'),
    Bus(
        id: '66190',
        startLocation: 'Hospital',
        destination: 'Agip',
        channelId: '2542299',
        apiKey: 'C9Q9Y9SR9WCTGQFH'),
    Bus(
        id: '57090',
        startLocation: 'Merkato',
        destination: 'Hospital',
        channelId: '254399',
        apiKey: 'C9Q9Y9SR9WCTGQFH'),
    Bus(
        id: '47861',
        startLocation: 'Merkato',
        destination: 'Ferenj Arada',
        channelId: '2544299',
        apiKey: 'C9Q9Y9SR9WCTGQFH'),
    Bus(
        id: '00035',
        startLocation: 'Ferenj Arada',
        destination: 'Ajip',
        channelId: '2546299',
        apiKey: 'C9Q9Y9SR9WCTGQFH'),
    Bus(
        id: '23116',
        startLocation: 'Merkato',
        destination: 'Gebriel',
        channelId: '2554526',
        apiKey: 'Q89M9ONZ57Y0HMMM'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus List'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text('Bus ID: ${bus.id}'),
              subtitle:
                  Text('From: ${bus.startLocation} To: ${bus.destination}'),
              onTap: () {
                //Get.to(() => BusDetailPage(bus: bus));
              },
            ),
          );
        },
      ),
    );
  }
}

class Bus {
  final String id;
  final String startLocation;
  final String destination;
  final String channelId;
  final String apiKey;

  Bus({
    required this.id,
    required this.startLocation,
    required this.destination,
    required this.channelId,
    required this.apiKey,
  });
}
