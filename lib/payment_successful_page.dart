import 'package:flutter/material.dart';
import 'package:iyzi/bpara.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iyzi/login.dart';
import 'package:iyzi/payment.dart';
import 'globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final String id = FirebaseAuth.instance.currentUser!.uid;

CollectionReference users = FirebaseFirestore.instance.collection('Users');
num paraekle = globals.addbpara + globals.varbpara;

Future<void> updateUser() {
  return users
      .doc(id)
      .update({'bpara': paraekle})
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}

class PaymentSuccessfulPage extends StatelessWidget {
  const PaymentSuccessfulPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Ödeme başarılı!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.green),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset('assets/images/payment_successful.png'),
              const SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  updateUser();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const BPara(
                                title: '',
                              )));
                },
                child: const Text(
                  'Anasayfam',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.lightGreen,
              )
            ],
          ),
        ),
      ),
    );
  }
}
