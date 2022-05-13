import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iyzi/login.dart';
import 'package:iyzi/payment.dart';
import 'globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iyzico/iyzico.dart';

class BPara extends StatefulWidget {
  const BPara({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _BParaState createState() => _BParaState();
}

class _BParaState extends State<BPara> {
  num _counter = 0;
  num _defaultValue = 0;

  final FirebaseAuth auth = FirebaseAuth.instance;

  final String id = FirebaseAuth.instance.currentUser!.uid;

  final String recid = "06FFZTZj0rO6uztDiZai3aL5KEt2";

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  //Gönderici para güncelleme
  Future<void> updateSenderUser() {
    return users
        .doc(id)
        .update({'bpara': FieldValue.increment(-globals.sendbpara)})
        .then((value) => print("Sender Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //Alıcı para güncelleme
  Future<void> updateReceiverUser() {
    return users
        .doc(recid)
        .update({'bpara': FieldValue.increment(globals.sendbpara)})
        .then((value) => print("Receiver Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //Kullanıcı mail gösterme
  inputData() {
    final User? user = auth.currentUser;
    final mail = user!.email;
    return mail.toString();
    // here you write the codes to input the data into firestore
  }

  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return Scaffold(
      appBar: AppBar(
        title: Text(inputData()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Hesaptaki parayı gösterme
            FutureBuilder<DocumentSnapshot>(
              future: users.doc(id).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  globals.varbpara = data['bpara'];
                  return Text("Hesabınızdaki Bpara: ${data['bpara']}");
                }
                return const Text("Yükleniyor...");
              },
            ),
            const SizedBox(height: 100),
            Text(
              'Seçilen Bpara: $_counter',
            ),
            Counter(
              color: Colors.blue,
              textStyle: const TextStyle(
                fontSize: 20.0,
              ),
              initialValue: _defaultValue,
              minValue: 0,
              maxValue: 100,
              step: 1,
              decimalPlaces: 0,
              onChanged: (value) {
                setState(() {
                  _defaultValue = value;
                  _counter = value;
                });
              },
            ),
            ElevatedButton.icon(
              onPressed: () {
                globals.addbpara = _counter;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const PaymentPage(
                              title: '',
                            )));
              },
              icon: const Icon(
                Icons.payment,
              ),
              label: const Text('Yükle'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                globals.sendbpara = _counter;
                updateSenderUser();
                updateReceiverUser();
                setState(() {});
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Transfer'),
                    content: const Text('Bpara transferi başarılı.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.send_rounded,
              ),
              label: const Text('Transfer'),
            ),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.money,
              ),
              label: const Text('Para çek'),
            ),
          ],
        ),
      ),
    );
  }
}

typedef CounterChangeCallback = void Function(num value);

class Counter extends StatefulWidget {
  final CounterChangeCallback onChanged;

  Counter({
    Key? key,
    required num initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.decimalPlaces,
    required this.color,
    required this.textStyle,
    this.step = 1,
    this.buttonSize = 25,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  ///min value user can pick
  final num minValue;

  ///max value user can pick
  final num maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  num selectedValue;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;

  /// indicates the color of fab used for increment and decrement
  Color color;

  /// text syle
  TextStyle textStyle;

  final double buttonSize;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  void _incrementCounter() {
    if (widget.selectedValue + widget.step <= widget.maxValue) {
      widget.onChanged((widget.selectedValue + widget.step));
    }
  }

  void _decrementCounter() {
    if (widget.selectedValue - widget.step >= widget.minValue) {
      widget.onChanged((widget.selectedValue - widget.step));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: widget.buttonSize,
            height: widget.buttonSize,
            child: FloatingActionButton(
              heroTag: "1",
              onPressed: _decrementCounter,
              elevation: 2,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
              backgroundColor: widget.color,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4.0),
            child: Text(
                '${num.parse((widget.selectedValue).toStringAsFixed(widget.decimalPlaces))}',
                style: widget.textStyle),
          ),
          SizedBox(
            width: widget.buttonSize,
            height: widget.buttonSize,
            child: FloatingActionButton(
              heroTag: "2",
              onPressed: _incrementCounter,
              elevation: 2,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
              backgroundColor: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}
