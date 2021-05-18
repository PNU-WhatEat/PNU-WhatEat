import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:what_eat/UserData.dart';

class UserInformation with ChangeNotifier {
  final FirebaseAuth _fAuth = FirebaseAuth.instance; // Firebase 인증 플러그인의 인스턴스
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User _user; // Firebase에 로그인 된 사용자
  UserData info = UserData();

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

  Future<bool> _saveOnFirebase(String uid, String name, String email, String phoneNumber) async {
    try {
      await FirebaseFirestore.instance.collection("User").doc(uid).set({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'follower': 0,
        'following': 0,
        'like': 0,
        'review': 0,
        'visited': 0,
        'favorite': 0,
        'storeRef': null,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _getInfoFromFirebase(String uid) async {
    try {
      await FirebaseFirestore.instance.collection("User").doc(uid).get().then((doc) {
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
          storeRef: doc["storeRef"],
        );
        notifyListeners();
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // 최근 Firebase에 로그인한 사용자의 정보 획득
  void _prepareUser() {
    if (_fAuth.currentUser != null) {
      _getInfoFromFirebase(_fAuth.currentUser.uid);
    }
    setUser(_fAuth.currentUser);
  }

  // 이메일/비밀번호로 Firebase에 회원가입
  Future<bool> signUpWithEmail(String name, String phoneNumber, String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        // 인증 메일 발송
        result.user.sendEmailVerification();
        // 새로운 계정 생성이 성공하였으므로 기존 계정이 있을 경우 로그아웃 시킴
        signOut();
        await _saveOnFirebase(result.user.uid, name, email, phoneNumber);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      setLastFBMessage(e.code);
      return false;
    }
  }

  // 이메일/비밀번호로 Firebase에 로그인
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      final result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        setUser(result.user);
        await _getInfoFromFirebase(_user.uid);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      setLastFBMessage(e.code);
      return false;
    }
  }

  // 구글 계정을 이용하여 Firebase에 로그인
  Future<bool> signInWithGoogleAccount() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final User user =
          (await _fAuth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      assert(user.uid == _fAuth.currentUser.uid);
      setUser(user);

      DocumentReference documentRef =  FirebaseFirestore.instance.collection("User").doc(user.uid);
        await documentRef.get().then((doc) async {
          if (!doc.exists)
            await documentRef.set({
              'name': user.displayName,
              'email': user.email,
              'phoneNumber': user.phoneNumber == null ? "" : "",
              'follower': 0,
              'following': 0,
              'like': 0,
              'review': 0,
              'visited': 0,
              'favorite': 0,
              'storeRef': null,
            });
        });
      await _getInfoFromFirebase(user.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      setLastFBMessage(e.code);
      return false;
    }
  }

  // Firebase로부터 로그아웃
  Future<void> signOut() async {
    await _fAuth.signOut();
    info.set();
    setUser(null);
  }

  // 사용자에게 비밀번호 재설정 메일을 전송
  Future<void> sendPasswordResetEmail() async {
    await _fAuth.sendPasswordResetEmail(email: getUser().email);
  }

  // Firebase로부터 회원 탈퇴
  Future<void> withdrawalAccount() async {
    await getUser().delete();
    setUser(null);
  }

  // Firebase로부터 수신한 메시지 설정
  void setLastFBMessage(String msg) {
    _lastFirebaseResponse = msg;
  }

  // Firebase로부터 수신한 메시지를 반환하고 삭제
  String getLastFBMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = null;
    return returnValue;
  }

  Future<bool> setName(String name) async {
    try {
      await FirebaseFirestore.instance.collection("User").doc(_user.uid).update({'name' : name});
      info.name = name;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      print("Error@@@@@@@@@@@@@@@@@@@@@@@@@$e");
      return false;
    }
  }

  Future<bool> setPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseFirestore.instance.collection("User").doc(_user.uid).update({'phoneNumber' : phoneNumber});
      info.phoneNumber = phoneNumber;
      notifyListeners();
      return true;
    }
    on Exception catch (e) {
      print("Error@@@@@@@@@@@@@@@@@@@@@@@@@$e");
      return false;
    }
  }

  Future<bool> incrementFollowing() async {
    try {
      DocumentReference documentRef = FirebaseFirestore.instance.collection('User').doc(_user.uid);
      await documentRef.update({"following": FieldValue.increment(1)});
      await documentRef.get().then((doc) {
        info.following = doc['following'];
      });
      notifyListeners();
      return true;
    }
    on Exception catch (e) {
      print("Error@@@@@@@@@@@@@@@@@@@@@@@@@$e");
      return false;
    }
  }

  Future<bool> incrementReview() async {
    try {
      DocumentReference documentRef = FirebaseFirestore.instance.collection('User').doc(_user.uid);
      await documentRef.update({"review": FieldValue.increment(1)});
      await documentRef.get().then((doc) {
        info.review = doc['review'];
      });
      notifyListeners();
      return true;
    }
    on Exception catch (e) {
      print("Error@@@@@@@@@@@@@@@@@@@@@@@@@$e");
      return false;
    }
  }

  Future<bool> incrementVisited() async {
    try {
      DocumentReference documentRef = FirebaseFirestore.instance.collection('User').doc(_user.uid);
      await documentRef.update({"visited": FieldValue.increment(1)});
      await documentRef.get().then((doc) {
        info.visited = doc['visited'];
      });
      notifyListeners();
      return true;
    }
    on Exception catch (e) {
      print("Error@@@@@@@@@@@@@@@@@@@@@@@@@$e");
      return false;
    }
  }

  Future<bool> incrementFavorite() async {
    try {
      DocumentReference documentRef = FirebaseFirestore.instance.collection('User').doc(_user.uid);
      await documentRef.update({"favorite": FieldValue.increment(1)});
      await documentRef.get().then((doc) {
        info.favorite = doc['favorite'];
      });
      notifyListeners();
      return true;
    }
    on Exception catch (e) {
      print("Error@@@@@@@@@@@@@@@@@@@@@@@@@$e");
      return false;
    }
  }

  Future<bool> setStore(DocumentReference storeRef) async {
    try {
      FirebaseFirestore.instance.collection('User').doc(_user.uid).update({'storeRef' : storeRef});
      info.storeRef = storeRef;
    }
    on Exception catch (e) {
      print("Error@@@@@@@@@@@@@@@@@@@@@@@@@$e");
      return false;
    }
    notifyListeners();
    return true;
  }
  
}