import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// ignore: constant_identifier_names
const String UID = "uid";
const String NICKNAME = "nickname";
const String LOCATION = "location";

const String IMAGE_URI = 'imageUri';
const String TITLE = "title";
const String CATEGORY = "category";
const String PRICE = "price";
const String DESCRIPTION = "description";
const String TIMESTAMP = "timestamp";
const String REGISTER = "register";
const String EMAIL = "email";
const String ITEMID = "itemid";

class MyAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MyUser _myUser = MyUser.instance;
  final String _uri = "/UserData";

  Future _getDocs(String key, String value) async {
    //key: doc's index, value: document
    var result =
        await _firestore.collection(_uri).where(key, isEqualTo: value).get();
    var docs = result.docs.asMap();
    return docs;
  }

  Future _authenticateUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException {
      return;
    }
  }

  _loadUserData(String uid) async {
    var docs = await _getDocs(UID, uid);
    if (docs == null || docs.isEmpty || docs[0] == null) {
      print("!docs null or empty");
      return;
    }
    Map data = docs[0].data() as Map;
    if (data[UID] == null || data[NICKNAME] == null || data[LOCATION] == null) {
      print("!null from user database");
      return;
    }
    if (data.isEmpty) {
      print("!user not exist");
      return;
    }
    return data;
  }

  _isNicknameTaken(String nickname) async {
    var data = await _getDocs(NICKNAME, nickname);
    if (data == null || data.isEmpty) {
      return false;
    }
    return true;
  }

  Future _verifyUser(String email, String password) async {
    try {
      UserCredential userInfo = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userInfo.user!.email == null) {
        print("!null from email");
        return;
      }
      _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
    }
  }

  //sign in
  signIn({required String email, required String password}) async {
    User? user = await _authenticateUser(email, password);
    if (user == null) {
      print("!failed verifying user");
      return;
    }
    Map<String, dynamic>? data = await _loadUserData(user.uid);
    if (data == null) {
      print("!failed load data");
      return;
    }
    _myUser.setUser(
        uid: data[UID], nickname: data[NICKNAME], location: data[LOCATION]);
    return true;
  }

  //sign out
  Future signOut() async => await FirebaseAuth.instance.signOut();

  //sign up
  signUp(
      {required String email,
      required String password,
      required String nickname}) async {
    if (await _isNicknameTaken(nickname)) {
      return;
    }
    await _verifyUser(email, password);
  }
}

class MyUser {
  //singleton
  MyUser._privateConstructor();
  static final MyUser _instance = MyUser._privateConstructor();
  static MyUser get instance => _instance;
  //member variable
  String? _uid;
  String? _nickname;
  String? _location;

  String? get getUid => _uid;
  String? get getNickname => _nickname;
  String? get getLocation => _location;

  setUser(
      {required String uid,
      required String nickname,
      required String location}) {
    _uid = uid;
    _nickname = nickname;
    _location = location;
  }
}

class Item {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final MyUser _myUser = MyUser._instance;
  final String _itemUri = '/ItemData';
  final String _storageUri = 'images/';

  _getCollection() {
    var result = _firestore.collection(_itemUri);
    return result;
  }

  String _getUuid() {
    Uuid uuid = const Uuid();
    return uuid.v4();
  }

  Future _registImage(XFile image) async {
    String str = _getUuid(); //무작위로 이름 생성
    //참조 생성
    Reference ref = _storage.ref().child('$_storageUri$str');
    //picker로 얻어온 이미지를 uint8list타입으로 반환
    //File(image.path)를 사용할 경우, 모바일 상에서는 동작 가능하지만, 웹 상에서 동작 안함.
    Uint8List imageData = await image.readAsBytes();
    await ref.putData(imageData);
    String imageurl = await ref.getDownloadURL();
    return imageurl;
  }

  registItem(
      {required XFile image,
      required String title,
      required String category,
      required int price,
      required String description}) async {
    var collection = _getCollection(); //아이템 정보 등록할 firestore
    String url = await _registImage(image);
    Map<String, dynamic> item = {
      UID: _myUser.getUid,
      ITEMID: _getUuid(),
      IMAGE_URI: url,
      TITLE: title,
      CATEGORY: category,
      PRICE: price.toString(),
      DESCRIPTION: description,
      TIMESTAMP: FieldValue.serverTimestamp(),
      REGISTER: _myUser.getNickname,
      LOCATION: _myUser.getLocation,
    };
    collection.add(item);
  }

  Future pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      print("!null from image");
      return;
    }
    return image;
  }

  findMyItems({required String uid}) {}

  itemStream() {}
}
