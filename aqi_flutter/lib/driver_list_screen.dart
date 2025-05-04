import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'driver_map_screen.dart';
import 'services/driver_service.dart';

class DriverListScreen extends StatefulWidget {
  final LatLng currentLocation;
  final Function(Map<String, dynamic>) onDriverSelected;
  final Map<String, dynamic> userData;

  const DriverListScreen({
    Key? key,
    required this.currentLocation,
    required this.onDriverSelected,
    required this.userData,
  }) : super(key: key);

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  List<Map<String, dynamic>> _driversWithDistance = [];
  bool _isLoading = true;
  String? _errorMessage;
  final DriverService _driverService = DriverService();

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    try {
      final drivers = await _driverService.getDrivers();
      setState(() {
        _driversWithDistance = drivers.map((driver) {
          final distance = Geolocator.distanceBetween(
            widget.currentLocation.latitude,
            widget.currentLocation.longitude,
            driver['lat'] ?? 0.0,
            driver['lng'] ?? 0.0,
          );
          
          final driverWithDistance = Map<String, dynamic>.from(driver);
          driverWithDistance['distance'] = distance;
          return driverWithDistance;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _getInitial(String? name) {
    if (name == null || name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Жолооч нарын жагсаалт'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadDrivers,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDrivers,
                        child: Text('Дахин оролдох'),
                      ),
                    ],
                  ),
                )
              : _driversWithDistance.isEmpty
                  ? Center(
                      child: Text('Жолооч олдсонгүй'),
                    )
                  : ListView.builder(
                      itemCount: _driversWithDistance.length,
                      itemBuilder: (context, index) {
                        final driver = _driversWithDistance[index];
                        
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              _getInitial(driver['first_name']),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            '${driver['first_name'] ?? 'Нэргүй'} ${driver['last_name'] ?? ''}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (driver['phone_number'] != null)
                                Text('Утас: ${driver['phone_number']}'),
                              if (driver['license_number'] != null)
                                Text('Жолоочийн үнэмлэх: ${driver['license_number']}'),
                              if (driver['location'] != null)
                                Text('Байршил: ${driver['location']}'),
                              Text('Зай: ${(driver['distance'] / 1000).toStringAsFixed(2)} км'),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                driver['is_verified'] == true ? Icons.verified : Icons.pending,
                                color: driver['is_verified'] == true ? Colors.green : Colors.orange,
                              ),
                              Text(
                                driver['is_verified'] == true ? 'Баталгаажсан' : 'Хүлээгдэж буй',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: driver['is_verified'] == true ? Colors.green : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DriverMapScreen(
                                  userData: widget.userData,
                                  selectedDriver: driver,
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