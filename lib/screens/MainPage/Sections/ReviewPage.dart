import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final _store = FirebaseFirestore.instance;
final _storage = FirebaseStorage.instance;

class ReviewPage extends StatefulWidget {
  static const id = 'review_page';

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  File _image;
  bool isSelected = false;
  bool isGood = false;
  String content = '';

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title =
        (ModalRoute.of(context).settings.arguments as Map)['title'] as String;

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "리뷰 쓰기",
          style: TextStyle(
            color: Colors.orange,
          ),
        ),
        actions: [
          InkWell(
            onTap: getImage,
            child: Icon(
              Icons.image,
              color: Colors.black54,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Colors.black54,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          _image != null
              ? Image.file(
                  _image,
                )
              : SizedBox(),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    isSelected = true;
                    isGood = true;
                  });
                },
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Image.asset(
                      'images/good.png',
                      color:
                          isGood && isSelected ? Colors.orange : Colors.black54,
                      width: 100.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "맛있어요",
                      style: TextStyle(
                        color: isGood && isSelected
                            ? Colors.orange
                            : Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    isSelected = true;
                    isGood = false;
                  });
                },
                child: Column(
                  children: [
                    Image.asset(
                      'images/bad.png',
                      color: !isGood && isSelected
                          ? Colors.orange
                          : Colors.black54,
                      width: 100.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "맛없어요",
                      style: TextStyle(
                        color: !isGood && isSelected
                            ? Colors.orange
                            : Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: TextFormField(
              onChanged: (val) {
                content = val;
              },
              style: TextStyle(fontSize: 15.0),
              maxLines: ((MediaQuery.of(context).size.width *
                              (_image != null ? 0.7 : 0.8)) ~/
                          15.0)
                      .toInt() -
                  1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                hintText:
                    "주문하신 메뉴는 어떠셨나요?\n식당의 분위기나 서비스도 궁금해요.\n맛있는 사진과 함께 리뷰를 작성해 보세요!",
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.0,
                ),
                hintMaxLines: 3,
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: StreamBuilder<QuerySnapshot>(
                stream: _store
                    .collection('St_temp')
                    .where('title', isEqualTo: title)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  List reviews = [];
                  final Map<String, dynamic> snapshotMap = snapshot?.data?.docs?.elementAt(0)?.data() as Map ?? {};
                  if (snapshotMap.containsKey('review')) {
                    reviews = snapshotMap['review'];
                  }
                  return TextButton(
                    onPressed: () async {
                      if (content.length != 0 && _image != null) {
                        try {
                          _store
                              .collection('St_temp')
                              .doc((await _store
                                      .collection('St_temp')
                                      .where('title', isEqualTo: title)
                                      .limit(1)
                                      .get())
                                  .docs[0]
                                  .id)
                              .update({
                            'review': [
                              ...reviews,
                              {
                                'reviewNo': (reviews.length + 1)
                                    .toString()
                                    .padLeft(3, '0'),
                                'isGood': isGood,
                                'content': content,
                              }
                            ],
                          });
                          _storage
                              .ref(
                                  'reviewImage/$title/${(reviews.length + 1).toString().padLeft(3, '0')}')
                              .putFile(_image);
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alert!'),
                              content: Text("내용과 사진을 입력해 주세요."),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context, "OK");
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        content.length != 0 ? Colors.orange : Colors.black54,
                      ),
                    ),
                    child: Text(
                      "작성완료",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
