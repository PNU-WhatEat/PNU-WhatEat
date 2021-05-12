import 'package:flutter/cupertino.dart';

class Info with ChangeNotifier {
  String name;
  String email;
  String phoneNumber;
  int follower;
  int following;
  int like;
  int review;
  int visited;
  int favorite;

  Info({this.name="0", this.email="0", this.phoneNumber="0", this.follower=0, this.following=0, this.like=0, this.review=0, this.visited=0, this.favorite=0});

  void set({String name : "0", String email : "0", String phoneNumber : "0", int follower : 0, int following : 0, int like : 0, int review : 0, int visited : 0, int favorite : 0}) {
    this.name = name;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.follower = follower;
    this.following = following;
    this.like = like;
    this.review = review;
    this.visited = visited;
    this.favorite = favorite;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
    notifyListeners();
  }

  void incrementFollowing() {
    ++this.following;
    notifyListeners();
  }

  void incrementReview() {
    ++this.review;
    notifyListeners();
  }

  void incrementVisited() {
    ++this.visited;
    notifyListeners();
  }

  void incrementFavorite() {
    ++this.favorite;
    notifyListeners();
  }
}