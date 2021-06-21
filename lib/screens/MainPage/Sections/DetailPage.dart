import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Detail {
  final String updateDate, address, category, detailLink, title, contact, image;
  final List menu;
  final Map location;

  Detail(
      {this.updateDate,
      this.address,
      this.location,
      this.category,
      this.detailLink,
      this.title,
      this.image,
      this.contact,
      this.menu});

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      address: json['address'],
      updateDate: json['updateDate'],
      contact: json['contact'],
      location: json['location'],
      menu: json['menu'],
      category: json['category'],
      detailLink: json['detailLink'],
      title: json['title'],
      image: json['image'],
    );
  }
}

class DetailPage extends StatefulWidget {
  static const id = 'detail_page';

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor myIcon;

  Future<String> getAddr() async {
    Detail data =
        Detail.fromJson(ModalRoute.of(context).settings.arguments as Map);
    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?language=ko&latlng=${data.location['y']},${data.location['x']}&key=AIzaSyDIk4qJqTrBB2fbT-f_x1m33wIM-GJ3q7Y'));
    return json.decode(response.body)['results'][0]['formatted_address'];
  }

  @override
  Widget build(BuildContext context) {
    Detail data =
        Detail.fromJson(ModalRoute.of(context).settings.arguments as Map);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    data.image != null
                        ? Image.network('https:${data.image}')
                        : SizedBox(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 15.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.remove_red_eye_sharp,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text("0"),
                                ],
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'images/pen.png',
                                    width: 15.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text("0"),
                                ],
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text("0"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Divider(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          icon: Icons.star_border,
                          buttonLabel: "가고싶다",
                          onPressed: () {},
                        ),
                        CustomButton(
                          icon: Icons.location_pin,
                          buttonLabel: "가봤어요",
                          onPressed: () {},
                        ),
                        CustomButton(
                          buttonLabel: "리뷰쓰기",
                          onPressed: () {},
                        ),
                        CustomButton(
                          icon: Icons.camera_alt_outlined,
                          buttonLabel: "사진올리기",
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: getAddr(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 100.0,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                double.tryParse(data.location['y']) ?? 0.0,
                                double.tryParse(data.location['x']) ?? 0.0,
                              ),
                              zoom: 15.0,
                            ),
                            onMapCreated: (controller) {
                              _controller.complete(controller);
                            },
                            markers: {
                              Marker(
                                markerId: MarkerId("1"),
                                position: LatLng(
                                  double.tryParse(data.location['y']) ?? 0.0,
                                  double.tryParse(data.location['x']) ?? 0.0,
                                ),
                                icon: BitmapDescriptor.defaultMarker,
                              )
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomCircularButton(
                            icon: Icons.subdirectory_arrow_right,
                            buttonLabel: "길 찾기",
                            onPressed: () {},
                          ),
                          CustomCircularButton(
                            imagePath: 'images/car.png',
                            buttonLabel: "내비게이션",
                            onPressed: () {},
                          ),
                          CustomCircularButton(
                            icon: Icons.car_rental,
                            buttonLabel: "차 렌탈",
                            onPressed: () {},
                          ),
                          CustomCircularButton(
                            icon: Icons.document_scanner,
                            buttonLabel: "주소 복사",
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                color: Colors.white,
                child: MaterialButton(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String buttonLabel;

  CustomButton({this.onPressed, this.icon, this.buttonLabel});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Column(
        children: [
          icon != null
              ? Icon(
                  icon,
                  size: 30.0,
                  color: Colors.orange,
                )
              : Image.asset(
                  'images/pen.png',
                  width: 30.0,
                  color: Colors.orange,
                ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            buttonLabel,
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCircularButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String buttonLabel;
  final String imagePath;

  CustomCircularButton(
      {this.onPressed, this.icon, this.buttonLabel, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Column(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Center(
              child: icon != null && imagePath == null
                  ? Icon(
                      icon,
                      size: 30.0,
                      color: Colors.black,
                    )
                  : Image.asset(
                      imagePath,
                      width: 25.0,
                    ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            buttonLabel,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
