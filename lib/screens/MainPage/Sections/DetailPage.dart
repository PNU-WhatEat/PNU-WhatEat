import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:what_eat/screens/MainPage/Sections/ReviewPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

class Detail {
  final String updateDate,
      address,
      category,
      detailLink,
      title,
      contact,
      image,
      openhour;
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
      this.menu,
      this.openhour});

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
      openhour: json['openhour'],
    );
  }
}

final _store = FirebaseFirestore.instance;
final _storage = FirebaseStorage.instance;

class DetailPage extends StatefulWidget {
  static const id = 'detail_page';

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor myIcon;
  ScrollController _scrollController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  final picker = ImagePicker();

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Detail data =
        Detail.fromJson(ModalRoute.of(context).settings.arguments as Map);

    return StreamBuilder<QuerySnapshot>(
        stream: _store
            .collection('St_temp')
            .where('title', isEqualTo: data.title)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List reviews = [];
          List wantToGo = [];
          List previewImagePaths = [];
          final Map<String, dynamic> snapshotMap =
              snapshot?.data?.docs?.elementAt(0)?.data() as Map ?? {};
          if (snapshotMap.containsKey('review')) {
            reviews = snapshotMap['review'];
          }
          if (snapshotMap.containsKey('wantToGo')) {
            wantToGo = snapshotMap['wantToGo'];
          }
          if (snapshotMap.containsKey('previewImagePaths')) {
            previewImagePaths = snapshotMap['previewImagePaths'];
          }
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  AnimatedContainer(
                    height: _showAppbar ? 56.0 : 0.0,
                    duration: Duration(milliseconds: 200),
                    child: AppBar(
                      title: Text(data.title),
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.orange,
                      leading: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_drop_down_outlined),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.width * 0.3,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            return FutureBuilder(
                                                future: _storage
                                                    .ref(
                                                    previewImagePaths[index])
                                                    .getDownloadURL(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return SizedBox();
                                                  }
                                                  return Image.network(
                                                    snapshot.data,
                                                  );
                                                });
                                          },
                                          itemCount: previewImagePaths.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),
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
                                              Text(
                                                reviews.length.toString(),
                                              ),
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
                                              Text(wantToGo.length.toString()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Divider(),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomButton(
                                      icon: Icons.details,
                                      buttonLabel: "상세보기",
                                      onPressed: () {
                                        launch(data.detailLink);
                                      },
                                    ),
                                    CustomButton(
                                      icon: wantToGo.contains("백도연")
                                          ? Icons.star
                                          : Icons.star_border,
                                      buttonLabel: "가고싶다",
                                      onPressed: () async {
                                        if (!wantToGo.contains("백도연")) {
                                          try {
                                            _store
                                                .collection('St_temp')
                                                .doc((await _store
                                                        .collection('St_temp')
                                                        .where('title',
                                                            isEqualTo:
                                                                data.title)
                                                        .limit(1)
                                                        .get())
                                                    .docs[0]
                                                    .id)
                                                .update({
                                              'wantToGo': [...wantToGo, '백도연']
                                                  .toSet()
                                                  .toList(),
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        } else {
                                          try {
                                            wantToGo.remove('백도연');
                                            _store
                                                .collection('St_temp')
                                                .doc((await _store
                                                        .collection('St_temp')
                                                        .where('title',
                                                            isEqualTo:
                                                                data.title)
                                                        .limit(1)
                                                        .get())
                                                    .docs[0]
                                                    .id)
                                                .update({
                                              'wantToGo':
                                                  wantToGo.toSet().toList(),
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                      },
                                    ),
                                    CustomButton(
                                      buttonLabel: "리뷰쓰기",
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, ReviewPage.id,
                                            arguments: {
                                              'title': data.title,
                                            });
                                      },
                                    ),
                                    CustomButton(
                                      icon: Icons.camera_alt_outlined,
                                      buttonLabel: "사진올리기",
                                      onPressed: () async {
                                        if (data.image != null) {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Alert!'),
                                                content: Text(
                                                    "이미 해당 식당에 대한 사진이 존재합니다."),
                                                actions: [
                                                  TextButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, "OK");
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          try {
                                            final newPath =
                                                'reviewImage/${data.title}/previewImage${(previewImagePaths.length + 1).toString().padLeft(3, '0')}';
                                            _store
                                                .collection('St_temp')
                                                .doc((await _store
                                                        .collection('St_temp')
                                                        .where('title',
                                                            isEqualTo:
                                                                data.title)
                                                        .limit(1)
                                                        .get())
                                                    .docs[0]
                                                    .id)
                                                .update({
                                              'previewImagePaths': [
                                                ...previewImagePaths,
                                                newPath
                                              ],
                                            });
                                            final pickedFile =
                                                await picker.getImage(
                                                    source:
                                                        ImageSource.gallery);
                                            await _storage
                                                .ref(newPath)
                                                .putFile(File(pickedFile.path));
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                      },
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
                                  Text(
                                    data.address,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 100.0,
                                      child: GoogleMap(
                                        mapType: MapType.normal,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            double.tryParse(
                                                    data.location['y']) ??
                                                0.0,
                                            double.tryParse(
                                                    data.location['x']) ??
                                                0.0,
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
                                              double.tryParse(
                                                      data.location['y']) ??
                                                  0.0,
                                              double.tryParse(
                                                      data.location['x']) ??
                                                  0.0,
                                            ),
                                            icon:
                                                BitmapDescriptor.defaultMarker,
                                          )
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Divider(),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      CustomCircularButton(
                                        icon: Icons.subdirectory_arrow_right,
                                        buttonLabel: "길 찾기",
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Alert!'),
                                                content: Text("지원 예정입니다."),
                                                actions: [
                                                  TextButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, "OK");
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      CustomCircularButton(
                                        icon: Icons.document_scanner,
                                        buttonLabel: "주소 복사",
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: data.address))
                                              .then((_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content:
                                                      Text('주소가 복사되었습니다!')),
                                            );
                                            Timer(Duration(milliseconds: 500),
                                                () {
                                              ScaffoldMessenger.of(context)
                                                  .clearSnackBars();
                                            });
                                          });
                                        },
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
                            width: double.infinity,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  showAdaptiveActionSheet(
                                    context: context,
                                    title: Text('Title'),
                                    actions: [
                                      BottomSheetAction(
                                          title: Text('전화하기: ${data.contact}'),
                                          onPressed: () =>
                                              launch("tel://${data.contact}")),
                                    ],
                                    cancelAction: CancelAction(
                                        title: Text(
                                            '취소')), // onPressed parameter is optional by default will dismiss the ActionSheet
                                  );
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.call,
                                      ),
                                      Text(
                                        "전화로 예약하기",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          data.openhour != null && data.menu != null
                              ? Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 10.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "편의정보",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          data.openhour,
                                        ),
                                        Text(
                                          "메뉴",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        ListView.separated(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                              height: 10.0,
                                            );
                                          },
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(data.menu[index]['name']),
                                                DottedLine(
                                                  direction: Axis.horizontal,
                                                  lineLength:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.7,
                                                  lineThickness: 1.0,
                                                  dashLength: 4.0,
                                                  dashColor: Colors.black,
                                                  dashRadius: 0.0,
                                                  dashGapLength: 4.0,
                                                  dashGapColor:
                                                      Colors.transparent,
                                                  dashGapRadius: 0.0,
                                                ),
                                                Text(data.menu[index]['price']),
                                              ],
                                            );
                                          },
                                          itemCount: data.menu.length,
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "리뷰",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      height: 10.0,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        child: Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                        ),
                                                        backgroundColor:
                                                            Colors.orange,
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        "백도연",
                                                      )
                                                    ],
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        reviews[index]['isGood']
                                                            ? 'images/good.png'
                                                            : 'images/bad.png',
                                                        width: 30.0,
                                                        color: Colors.orange,
                                                      ),
                                                      Text(
                                                        reviews[index]['isGood']
                                                            ? '맛있어요'
                                                            : '맛없어요',
                                                        style: TextStyle(
                                                          color: Colors.orange,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              FutureBuilder(
                                                  future: _storage
                                                      .ref(
                                                          'reviewImage/${data.title}/${reviews[index]['reviewNo']}')
                                                      .getDownloadURL(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                    return Image.network(
                                                        snapshot.data);
                                                  }),
                                              Text(
                                                reviews[index]['content'],
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: reviews.length,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
