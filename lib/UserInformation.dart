import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:what_eat/UserInfo.dart';

class UserInformation with ChangeNotifier {
  final FirebaseAuth fAuth = FirebaseAuth.instance; // Firebase 인증 플러그인의 인스턴스
  User _user; // Firebase에 로그인 된 사용자
  Info info = Info();

  String _lastFirebaseResponse = ""; // Firebase로부터 받은 최신 메시지(에러 처리용)

  UserInformation() {
    _prepareUser();
  }

  User getUser() {
    return _user;
  }

  void setUser(User value) {
    _user = value;
    notifyListeners();
  }

  // 최근 Firebase에 로그인한 사용자의 정보 획득
  _prepareUser() {
    setUser(fAuth.currentUser);
  }

  // 이메일/비밀번호로 Firebase에 회원가입
  Future<bool> signUpWithEmail(String name, String phoneNumber, String email, String password) async {
    try {
      UserCredential result = await fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        // 인증 메일 발송
        result.user.sendEmailVerification();
        // 새로운 계정 생성이 성공하였으므로 기존 계정이 있을 경우 로그아웃 시킴
        signOut();
        FirebaseFirestore.instance.collection("User").doc(result.user.uid).set({
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'follower': 0,
          'following': 0,
          'like': 0,
          'review': 0,
          'visited': 0,
          'favorite': 0,
        });
        return true;
      }
      return false;
    } on Exception catch (e) {
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }

  // 이메일/비밀번호로 Firebase에 로그인
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      var result = await fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        setUser(result.user);
        FirebaseFirestore.instance.collection("User").doc(_user.uid).get().then((doc) {
          info.set(
              name: doc["name"],
              email: doc["email"],
              phoneNumber: doc["phoneNumber"],
              follower: doc["follower"],
              following: doc["following"],
              like: doc["like"],
              review: doc["review"],
              visited: doc["visited"],
              favorite: doc["favorite"],
            );
            print(doc['name']);
            notifyListeners();
        });
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    } on Exception catch (e) {
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    } catch (e) {
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }

  // Firebase로부터 로그아웃
  signOut() async {
    await fAuth.signOut();
    info.set();
    setUser(null);
  }

  // 사용자에게 비밀번호 재설정 메일을 영어로 전송 시도
  sendPasswordResetEmailByEnglish() async {
    await fAuth.setLanguageCode("en");
    sendPasswordResetEmail();
  }

  // 사용자에게 비밀번호 재설정 메일을 한글로 전송 시도
  sendPasswordResetEmailByKorean() async {
    await fAuth.setLanguageCode("ko");
    sendPasswordResetEmail();
  }

  // 사용자에게 비밀번호 재설정 메일을 전송
  sendPasswordResetEmail() async {
    fAuth.sendPasswordResetEmail(email: getUser().email);
  }

  // Firebase로부터 회원 탈퇴
  withdrawalAccount() async {
    await getUser().delete();
    setUser(null);
  }

  // Firebase로부터 수신한 메시지 설정
  setLastFBMessage(String msg) {
    _lastFirebaseResponse = msg;
  }

  // Firebase로부터 수신한 메시지를 반환하고 삭제
  getLastFBMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = null;
    return returnValue;
  }
}