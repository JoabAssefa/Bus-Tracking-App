import 'package:flutter/material.dart';
import '/services/thing_speak_service.dart';
import '/util/location_util.dart';
import 'bus_list_page.dart';

class BusComparePage extends StatefulWidget {
  final String destination;
  final double startLatitude;
  final double startLongitude;
  final List<Bus> availableBuses;

  BusComparePage({
    super.key,
    required this.destination,
    required this.startLatitude,
    required this.startLongitude,
    required this.availableBuses,
  });

  @override
  _BusComparePageState createState() => _BusComparePageState();
}

class _BusComparePageState extends State<BusComparePage> {
  late Future<List<Map<String, dynamic>>> _busDataFuture;

  @override
  void initState() {
    super.initState();
    _busDataFuture = _fetchAllBusData();
  }

  Future<List<Map<String, dynamic>>> _fetchAllBusData() async {
    List<Map<String, dynamic>> busDataList = [];
    ThingSpeakService thingSpeakService = ThingSpeakService();

    for (var bus in widget.availableBuses) {
      try {
        var busData =
            await thingSpeakService.fetchLatestData(bus.channelId, bus.apiKey);
        busData['id'] = bus.id; // Add bus ID to the data
        busDataList.add(busData);
      } catch (e) {
        // Handle the error if needed
      }
    }

    return busDataList;
  }

  void _refreshData() {
    setState(() {
      _busDataFuture = _fetchAllBusData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Bus'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _busDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final busDataList = snapshot.data!;

            // Filter out stopped buses
            final movingBuses =
                busDataList.where((busData) => !busData['isStopped']).toList();

            // Check if there are any moving buses
            if (movingBuses.isEmpty) {
              return const Center(
                  child: Text('All assigned buses are stopped right now.'));
            }

            // Filter for approaching buses
            final approachingBuses = movingBuses.where((busData) {
              final currentDistance = LocationUtils.calculateDistance(
                busData['currentLatitude'],
                busData['currentLongitude'],
                widget.startLatitude,
                widget.startLongitude,
              );
              final previousDistance = LocationUtils.calculateDistance(
                busData['previousLatitude'],
                busData['previousLongitude'],
                widget.startLatitude,
                widget.startLongitude,
              );
              return previousDistance > currentDistance;
            }).toList();

            // Check if there are any approaching buses
            if (approachingBuses.isEmpty) {
              return const Center(
                  child: Text(
                      'No bus is approaching you, please check back later.'));
            }

            // Sort the approaching buses by distance
            approachingBuses.sort((a, b) {
              final distanceA = LocationUtils.calculateDistance(
                a['currentLatitude'],
                a['currentLongitude'],
                widget.startLatitude,
                widget.startLongitude,
              );
              final distanceB = LocationUtils.calculateDistance(
                b['currentLatitude'],
                b['currentLongitude'],
                widget.startLatitude,
                widget.startLongitude,
              );
              return distanceA.compareTo(distanceB);
            });

            // Get the closest bus
            final closestBus = approachingBuses.first;
            final closestBusDistance = LocationUtils.calculateDistance(
              closestBus['currentLatitude'],
              closestBus['currentLongitude'],
              widget.startLatitude,
              widget.startLongitude,
            );
            final closestBusETA = LocationUtils.calculateETA(
              closestBusDistance,
              closestBus['currentSpeed'],
            );

            final closestBusETAMinutes = closestBusETA * 60;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Recommended Bus ID: ${closestBus['id']}'),
                  const SizedBox(height: 10),
                  Text(
                      'Distance to bus: ${closestBusDistance.toStringAsFixed(2)} km'),
                  const SizedBox(height: 10),
                  Text(
                      'Estimated time of arrival: ${closestBusETAMinutes.toStringAsFixed(2)} minutes'),
                  const SizedBox(height: 10),
                  const Text('The bus is approaching you.'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
