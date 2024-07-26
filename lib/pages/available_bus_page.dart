import 'package:flutter/material.dart';
import 'bus_list_page.dart';
import 'bus_compare_page.dart';
import 'package:get/get.dart';
import '/controller/userlocationcontroller.dart';

class AvailableBusesPage extends StatelessWidget {
  final String startLocation;
  final String destination;

  AvailableBusesPage({
    super.key,
    required this.startLocation,
    required this.destination,
  });

  final ulController = Get.put(UserLocationController());

  @override
  Widget build(BuildContext context) {
    // Filter buses based on the start and destination locations
    final List<Bus> availableBuses = BusListPage.buses.where((bus) {
      return (bus.startLocation.toLowerCase() == startLocation.toLowerCase() &&
              bus.destination.toLowerCase() == destination.toLowerCase()) ||
          (bus.startLocation.toLowerCase() == destination.toLowerCase() &&
              bus.destination.toLowerCase() == startLocation.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Buses'),
        backgroundColor: Colors.orange,
      ),
      body: Obx(() {
        if (!ulController.isLoadedMap.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return availableBuses.isEmpty
            ? Center(
                child: Text(
                  'No buses available from $startLocation to $destination.',
                  style: const TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: availableBuses.length,
                itemBuilder: (context, index) {
                  final bus = availableBuses[index];
                  return Card(
                    margin: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text('Bus ID: ${bus.id}'),
                      subtitle: Text(
                          'From: ${bus.startLocation} To: ${bus.destination}'),
                      onTap: () {
                        // Handle bus detail navigation if needed
                      },
                    ),
                  );
                },
              );
      }),
      floatingActionButton: Obx(() {
        if (!ulController.isLoadedMap.value) {
          return const SizedBox.shrink(); // Hide the button if the location is not loaded
        }

        return FloatingActionButton.extended(
          backgroundColor: Colors.orange,
          onPressed: () {
            Get.to(() => BusComparePage(
                  destination: destination,
                  startLatitude: ulController.user.value.latitude!,
                  startLongitude: ulController.user.value.longitude!,
                  availableBuses: availableBuses,
                ));
          },
          label: const Text('Recommend bus'),
        );
      }),
    );
  }
}
