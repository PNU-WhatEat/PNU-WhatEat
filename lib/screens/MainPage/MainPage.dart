import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:what_eat/screens/MainPage/Sections/DetailPage.dart';
import 'package:http/http.dart' as http;

final _store = FirebaseFirestore.instance;
final _storage = FirebaseStorage.instance;

class MainPage extends StatefulWidget {
  static const id = 'main_page';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double curLng, curLat;
  double distance;

  double degreesToRadians(degrees) {
    return degrees * pi / 180.0;
  }

  bool isInsideDistanceInKmBetweenEarthCoordinates(
      double lat, double lon, double distance) {
    var earthRadiusKm = 6371.0;

    var dLat = degreesToRadians(lat - (curLat ?? 0.0));
    var dLon = degreesToRadians(lon - (curLng ?? 0.0));

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(degreesToRadians((curLat ?? 0.0))) *
            cos(degreesToRadians(lat));
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c < distance;
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();
      if (statuses[Permission.location].isGranted) {
        final lngLat = await Geolocator.getCurrentPosition();
        curLat = lngLat.latitude.toDouble();
        curLng = lngLat.longitude.toDouble();
        print(curLat);
        setState(() {
          distance = 3.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          50.0,
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leadingWidth: MediaQuery.of(context).size.width * 0.25,
          leading: Padding(
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "?????? ???????????? ?????????",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8.0,
                  ),
                ),
                FutureBuilder<http.Response>(
                  future: http.get(Uri.parse(
                      'https://maps.googleapis.com/maps/api/geocode/json?language=KO&latlng=$curLat,$curLng&key=AIzaSyDIk4qJqTrBB2fbT-f_x1m33wIM-GJ3q7Y')),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Text(
                      "?????? ${json.decode(snapshot.data.body)['results'][0]['formatted_address'].split(' ')[2]}",
                      style: TextStyle(color: Colors.black),
                    );
                  },
                )
              ],
            ),
          ),
          actions: [
            Icon(
              Icons.search,
              color: Colors.black54,
            ),
            Container(
              height: 10.0,
              child: VerticalDivider(
                width: 10.0,
              ),
            ),
            Icon(
              Icons.map,
              color: Colors.black54,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10.0,
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Text(
                            "?????????",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 10.0,
                            color: Colors.black54,
                          )
                        ],
                      ),
                      onTap: () {
                        showBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
                Row(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ),
                      color: Colors.black12,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_searching,
                                color: Colors.orangeAccent,
                                size: 12.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "${distance?.toInt() ?? 3}km",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            int temp = 0;
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('????????? ????????? ???????????????.'),
                                  content: TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      temp = int.tryParse(val) ?? 0;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "??????",
                                        filled: true,
                                        fillColor: Colors.grey.shade50),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text("??????"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            setState(() {
                              distance =
                                  double.tryParse(temp.toString()) ?? 0.0;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _store.collection('St_temp').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final _renderingSnapshots =
                      snapshot.data.docs.where((element) {
                    final lat = double.tryParse(
                            (element.data() as Map)['location']['y']) ??
                        0.0;
                    final lon = double.tryParse(
                            (element.data() as Map)['location']['x']) ??
                        0.0;
                    return isInsideDistanceInKmBetweenEarthCoordinates(
                      lat,
                      lon,
                      distance ?? 3.0,
                    );
                  }).toList();
                  final gridViewList =
                      List.generate(_renderingSnapshots.length, (index) {
                    final _data =
                        _renderingSnapshots.elementAt(index).data() as Map;
                    return InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _data['image'] != null
                                ? SizedBox(
                                    height: 150.0,
                                    child: Center(
                                      child: Image.network(
                                        'https:${_data['image'] ?? '//via.placeholder.com/150'}',
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  )
                                : _data['previewImagePaths'] != null &&
                                        _data['previewImagePaths'].length != 0
                                    ? FutureBuilder(
                                        future: _storage
                                            .ref(_data['previewImagePaths'][0])
                                            .getDownloadURL(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return SizedBox(
                                            height: 150.0,
                                            child: Center(
                                              child: Image.network(
                                                snapshot.data,
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                              ),
                                            ),
                                          );
                                        })
                                    : Center(
                                        child: Image.network(
                                          'https://via.placeholder.com/150',
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                            Text(
                              "${_data['title']}".length > 10
                                  ? "${index + 1}. ${"${_data['title']}".substring(0, 7)}..."
                                  : "${index + 1}. ${_data['title']}",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${_data['address'].split('??? ')[0]}???",
                              style: TextStyle(
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, DetailPage.id,
                              arguments: _data);
                        });
                  });
                  return GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 0.9,
                    children: gridViewList,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
