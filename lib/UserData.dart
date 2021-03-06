import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String name;
  String email;
  String phoneNumber;
  int follower;
  int following;
  int like;
  int review;
  int visited;
  int favorite;
  DocumentReference storeRef;

  UserData({this.name="0", this.email="0", this.phoneNumber="0", this.follower=0, this.following=0, this.like=0, this.review=0, this.visited=0, this.favorite=0, this.storeRef=null});

  void set({String name : "0", String email : "0", String phoneNumber : "0", int follower : 0, int following : 0, int like : 0, int review : 0, int visited : 0, int favorite : 0, DocumentReference storeRef : null}) {
    this.name = name;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.follower = follower;
    this.following = following;
    this.like = like;
    this.review = review;
    this.visited = visited;
    this.favorite = favorite;
    this.storeRef = storeRef;
  }
}