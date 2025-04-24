import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'driver_map_screen.dart';

class DriverListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> drivers;
  final LatLng currentLocation;
  final Function(Map<String, dynamic>) onDriverSelected;
  final Map<String, dynamic> userData;

  const DriverListScreen({
    Key? key,
    required this.drivers,
    required this.currentLocation,
    required this.onDriverSelected,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Жолооч нарын жагсаалт'),
      ),
      body: ListView.builder(
        itemCount: drivers.length,
        itemBuilder: (context, index) {
          final driver = drivers[index];
          final distance = Geolocator.distanceBetween(
            currentLocation.latitude,
            currentLocation.longitude,
            driver['lat'],
            driver['lng'],
          );
          
          final driverWithDistance = Map<String, dynamic>.from(driver);
          driverWithDistance['distance'] = distance;
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                driver['name'][0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(driver['name']),
            subtitle: Text('${driver['car']} - ${(distance / 1000).toStringAsFixed(2)} км'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                Text(driver['rating'].toString()),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriverMapScreen(
                    userData: userData,
                    selectedDriver: driverWithDistance,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 