import 'dart:core';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

final _store = FirebaseFirestore.instance;

class MainPage extends StatefulWidget {
  static const id = 'main_page';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double curLng, curLat;
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  ScrollController _scrollController = ScrollController();

  double degreesToRadians(degrees) {
    return degrees * pi / 180.0;
  }

  double distanceInKmBetweenEarthCoordinates(double lat, double lon) {
    var earthRadiusKm = 6371.0;

    var dLat = degreesToRadians(lat - curLat);
    var dLon = degreesToRadians(lon - curLng);

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(degreesToRadians(curLat)) *
            cos(degreesToRadians(lat));
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final lngLat = await Geolocator.getCurrentPosition();
      curLat = lngLat.latitude.toDouble();
      curLng = lngLat.longitude.toDouble();
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
                  "지금 보고있는 지역은",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8.0,
                  ),
                ),
                InkWell(
                  child: Row(
                    children: [
                      Text(
                        "부산 연제구",
                        style: TextStyle(color: Colors.black),
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
                            "평점순",
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
                                "3km",
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                          border: Border.all(
                            color: Colors.black54,
                          )),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 2.0),
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.adjust,
                                color: Colors.black54,
                                size: 12.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "필터",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
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
            RefreshIndicator(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: PaginateFirestore(
                  itemBuilderType: PaginateBuilderType.gridView,
                  itemsPerPage: 10,
                  scrollController: _scrollController,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (index, context, snapshot) {
                    final _data = snapshot.data() as Map;
                    double distance = distanceInKmBetweenEarthCoordinates(
                        double.tryParse(_data['location']['y']) ?? 35.0,
                        double.tryParse(_data['location']['x']) ?? 129.0);
                    print(distance);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Center(
                            child: Image.network(
                              'https:${_data['image'] ?? '//via.placeholder.com/150'}',
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                          height: 150.0,
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
                          "${_data['address'].split('구 ')[0]}구",
                          style: TextStyle(
                            fontSize: 11.0,
                          ),
                        ),
                      ],
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 0.9,
                  ),
                  // orderBy is compulsary to enable pagination
                  query: _store.collection('St_temp').orderBy('title'),
                  listeners: [
                    refreshChangeListener,
                  ],
                ),
              ),
              onRefresh: () async {
                refreshChangeListener.refreshed = true;
              },
            )
          ],
        ),
      ),
    );
  }
}
