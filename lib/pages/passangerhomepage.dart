import 'package:Bus_Tracking_App/pages/about_us_page.dart';
import 'package:Bus_Tracking_App/pages/available_bus_page.dart';
import 'package:Bus_Tracking_App/pages/bus_list_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '/controller/userlocationcontroller.dart';
import '/controller/notificationController.dart';
//import '/util/showdialogue.dart';
import '/util/textStyles.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassangerHomePage extends StatelessWidget {
  PassangerHomePage({super.key});

  final ulController = Get.put(UserLocationController());
  final nc = Get.put(NotificationController());

  final Completer<GoogleMapController> _controller = Completer();

  final TextEditingController startController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.orange),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bus.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'WELCOME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.directions_bus),
              title: const Text('Bus List'),
              onTap: () {
                //Navigator.pop(context);
                Get.to(() => BusListPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('About Us'),
              onTap: () {
                //Navigator.pop(context);
                Get.to(() => const AboutUsPage());
              },
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFFFF9B37)),
        child: Column(
          children: [
            Container(color: Colors.orange, child: textFieldPart(context)),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            Expanded(
                child: Container(
              color: Colors.white,
              child: googleM(context),
            )),
          ],
        ),
      ),
    );
  }

  Widget textFieldPart(context) {
    return Obx(() {
      if (!ulController.isLoadedAutoText.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Column(
          children: [
            SizedBox(
              child: Autocomplete(
                onSelected: (String text) {
                  //Get.to(BusListPage(destination: text));
                  startController.text = text;
                },
                optionsBuilder: ((textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  } else {
                    return ulController.autoList.where((p0) => p0
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  }
                }),
                fieldViewBuilder:
                    (context, startController, focusnode, onEditingComplete) {
                  return TextField(
                    controller: startController,
                    focusNode: focusnode,
                    onEditingComplete: onEditingComplete,
                    decoration: InputDecoration(
                        //labelText: "destination",
                        hintText: "Start",
                        hintStyle: MyTextStyle().subtitle2,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.blue)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.blue))),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: Autocomplete(
                onSelected: (String text) {
                  //Get.to(BusListPage(destination: text));
                  destinationController.text = text;
                },
                optionsBuilder: ((textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  } else {
                    return ulController.autoList.where((p0) => p0
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  }
                }),
                fieldViewBuilder: (context, destinationController, focusnode,
                    onEditingComplete) {
                  return TextField(
                    controller: destinationController,
                    focusNode: focusnode,
                    onEditingComplete: onEditingComplete,
                    decoration: InputDecoration(
                        //labelText: "destination",
                        hintText: "Destination",
                        hintStyle: MyTextStyle().subtitle2,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.blue)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.blue))),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final startLocation = startController.text;
                final destination = destinationController.text;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => AvailableBusesPage(
                            startLocation: startLocation,
                            destination: destination))));
                // Get.to(() => AvailableBusesPage(
                //       startLocation: startLocation,
                //       destination: destination,
                //     ));
              },
              child: const Text('Search Buses'),
            )
          ],
        ),
      );
    });
  }

  Obx googleM(BuildContext context) {
    return Obx(() {
      return SizedBox(
        child: ulController.isLoadedMap.value
            ? GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      ulController.user.value.latitude ?? 7.670190,
                      ulController.user.value.longitude ?? 36.833359,
                    ),
                    zoom: 16),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: ulController.isIconLoaded.value
                    ? Set<Marker>.of(ulController.markers.values)
                    : {
                        const Marker(
                          markerId: MarkerId("melat"),
                        )
                      })
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }
}
