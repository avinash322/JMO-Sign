import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TaggingScreen extends StatefulWidget {
  const TaggingScreen({super.key});

  @override
  State<TaggingScreen> createState() => _TaggingScreenState();
}

class _TaggingScreenState extends State<TaggingScreen> {
  LatLng _defaultLocation = const LatLng(-6.233385, 106.821412);
  late MapController _mapController;
  double accuracy = 50;
  List<Marker> _markers = [];
  String checkin = "-";
  String checkout = "-";
  bool _isLoading = false;

  Future<void> _getSavedLocationMarker() async {
    _mapController = MapController();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLatitude = prefs.getString('latitude');
    String? savedLongitude = prefs.getString('longitude');

    LatLng point =
        LatLng(double.parse(savedLatitude!), double.parse(savedLongitude!));

    _markers.add(
      Marker(
        point: point,
        child: const Icon(
          Icons.person,
          color: Colors.red,
          size: 30,
        ),
      ),
    );
    Future.delayed(Duration(milliseconds: 100), () {
      _mapController.move(_defaultLocation, 17);
    });
  }

  static bool calculateDistance(LatLng p1, LatLng p2, double accuracy) {
    final Distance distance = new Distance();
    double calculatedDistance = distance.as(LengthUnit.Meter, p1, p2);
    print("distance:" + calculatedDistance.toString());
    return accuracy > calculatedDistance;
  }

  void _setCheckin() async {
    print("jalan");
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLatitude = prefs.getString('latitude');
    String? savedLongitude = prefs.getString('longitude');

    LatLng point =
        LatLng(double.parse(savedLatitude!), double.parse(savedLongitude!));
    bool isPresent = calculateDistance(_defaultLocation, point, accuracy);

    if (isPresent) {
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(now);

      setState(() {
        checkin = formattedTime;
      });
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil mengisi absen datang! '),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Gagal mengisi absen datang karena jarak lokasi anda terlalu jauh'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _setCheckout() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLatitude = prefs.getString('latitude');
    String? savedLongitude = prefs.getString('longitude');

    LatLng point =
        LatLng(double.parse(savedLatitude!), double.parse(savedLongitude!));
    bool isPresent = calculateDistance(_defaultLocation, point, accuracy);

    if (isPresent) {
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(now);

      setState(() {
        checkout = formattedTime;
      });
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil mengisi absen pulang! '),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Gagal mengisi absen pulang karena jarak lokasi anda terlalu jauh'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showAttendanceModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Attendances',
                                style: TextStyle(
                                    color: Color(0xFF00008B),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _setCheckin,
                        child: Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: _isLoading
                              ? Center(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              Icons.door_back_door_outlined,
                                              size: 40,
                                              color: Colors.deepPurple,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: checkin == "-"
                                                      ? Color(0xFFFA8072)
                                                      : Color(0xFF90EE90),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.check,
                                                      color: checkin == "-"
                                                          ? Colors.red[700]
                                                          : Colors.green[700],
                                                      size: 15,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      checkin == "-"
                                                          ? "In Progress"
                                                          : 'Done',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: checkin == "-"
                                                              ? Colors.red[700]
                                                              : Colors
                                                                  .green[700],
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Check-In',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          checkin,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: checkin == "-" ? null : _setCheckout,
                        child: Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: _isLoading
                              ? Center(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              Icons.exit_to_app,
                                              size: 40,
                                              color: Colors.deepPurple,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: checkout == "-"
                                                      ? Color(0xFFFA8072)
                                                      : Color(0xFF90EE90),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.clear,
                                                      color: checkout == "-"
                                                          ? Colors.red[700]
                                                          : Colors.green[700],
                                                      size: 15,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      checkout == "-"
                                                          ? "In Progress"
                                                          : 'Done',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: checkout == "-"
                                                              ? Colors.red[700]
                                                              : Colors
                                                                  .green[700],
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Check-Out',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          checkout,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getSavedLocationMarker();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Geo-tagging Location'),
          actions: [
            DropdownButton<double>(
              value: accuracy,
              items: [50.0, 100.0, 200.0].map((double value) {
                return DropdownMenuItem<double>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (double? newValue) {
                setState(() {
                  accuracy = newValue ?? 50.0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.door_back_door_outlined),
              onPressed: () => _showAttendanceModal(context),
            ),
          ],
        ),
        body: _defaultLocation.latitude != 0
            ? FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  // onTap: (tapPosition, point) {
                  //   setState(() {
                  //     if (_markers.isNotEmpty) {
                  //       setState(() {
                  //         _markers.removeLast();
                  //         _markers.add(
                  //           Marker(
                  //             point: point,
                  //             child: const Icon(
                  //               Icons.pin_drop,
                  //               color: Colors.red,
                  //               size: 40,
                  //             ),
                  //           ),
                  //         );
                  //       });
                  //     } else {
                  //       _markers.add(
                  //         Marker(
                  //           point: point,
                  //           child: const Icon(
                  //             Icons.pin_drop,
                  //             color: Colors.red,
                  //             size: 40,
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //   });
                  // },
                  initialCenter: _defaultLocation,
                  initialZoom: 10,
                  minZoom: 0,
                  maxZoom: 20,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                        'net.tlserver6y.flutter_map_location_marker.example',
                    maxZoom: 19,
                  ),
                  LocationMarkerLayer(
                      position: LocationMarkerPosition(
                          latitude: _defaultLocation.latitude,
                          longitude: _defaultLocation.longitude,
                          accuracy: accuracy)),
                  MarkerLayer(
                    markers: _markers,
                  ),
                  // CurrentLocationLayer(
                  //   followOnLocationUpdate: FollowOnLocationUpdate.always,
                  //   turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                  //   style: const LocationMarkerStyle(
                  //     marker: DefaultLocationMarker(
                  //       color: Colors.white,
                  //       child: Icon(
                  //         Icons.navigation_outlined,
                  //         color: Colors.blue,
                  //       ),
                  //     ),
                  //     markerSize: Size(40, 40),
                  //     markerDirection: MarkerDirection.heading,
                  //   ),
                  // ),
                ],
              )
            : Container());
  }
}
