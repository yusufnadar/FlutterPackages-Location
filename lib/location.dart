import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Location? location;

  @override
  void initState() {
    super.initState();
    location = Location();
    getLocation();
  }

  getLocation()async{
    bool _serviceEnabled = await location!.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location!.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }else{
      print('konum açık');
    }

    PermissionStatus? _permissionGranted = await location!.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location!.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }else{
      print('izin verildi');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: StreamBuilder<LocationData>(
        stream: location!.onLocationChanged,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data!.longitude.toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    snapshot.data!.latitude.toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        locationMethod();
                      },
                      child: const Text('Location'))
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void locationMethod() async {
    //await location!.serviceEnabled();
    await location!.changeSettings(
        accuracy: LocationAccuracy.high, interval: 8000, distanceFilter: 0);
    var data = await location!.getLocation();
    print(data.longitude);
    location!.enableBackgroundMode(enable: true);
  }
}
