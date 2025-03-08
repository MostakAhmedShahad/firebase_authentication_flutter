import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Welcome')),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            _createData(UserModel(
              username: "shahad",
              age: 26,
              address: "dhaka",
            ));
          },
          child: Container(
            height: 200,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              'Tap to Add Data',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _createData(UserModel userModel) {
    final usercollection = FirebaseFirestore.instance.collection("users");
    String id = usercollection.doc().id;
    final newUser = UserModel(
      username: userModel.username,
      age: userModel.age,
      address: userModel.address,
      id: id,
    ).toJson();
    usercollection.doc(id).set(newUser);
  }
}

class UserModel {
  final String? username;
  final String? address;
  final int? age;
  final String? id;
  UserModel({this.id, this.username, this.address, this.age});
  static UserModel formSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshor) {
    return UserModel(
      username: snapshor['username'],
      address: snapshor['address'],
      age: snapshor['age'],
      id: snapshor['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"username": username, "age": 21, "id": id, "address": address};
  }
}
