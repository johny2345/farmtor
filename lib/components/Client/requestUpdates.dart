import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmtor/components/Client/requestUpdatesDetails.dart';

class RequestUpdatePage extends StatefulWidget {
  @override
  _RequestUpdatePageState createState() => _RequestUpdatePageState();
}

class _RequestUpdatePageState extends State<RequestUpdatePage> {
  var userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Updates'),
      ),
      body: getUserId(context),
    );
  }

  getUserId(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userId = snapshot.data.uid;
            return _getUpdateDetails(context);
          } else {
            print('prof details loading');
            return Material(
                child: Center(
              child: Image.asset(
                'assets/images/unnamed.gif',
                height: 70,
              ),
            ));
          }
        });
  }

  Widget _getUpdateDetails(BuildContext context) {
    print('------get request data-------');
    print(userId);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(userId)
          .collection('request')
          .orderBy('dateSchedule')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Material(
              child: Center(
            child: Image.asset(
              'assets/images/unnamed.gif',
              height: 70,
            ),
          ));
        } else {
          return _displayUpdateDetails(context, snapshot.data);
        }
      },
    );
  }

  _displayUpdateDetails(BuildContext context, QuerySnapshot snapshot) {
    return ListView(
      children: snapshot.documents.map((document) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0)),
            child: ListTile(
              leading: Icon(Icons.person),
              title: new Text(document['requestDetail']),
              onTap: () {
                print('--------------DOCUMENT ID: -------------------------');
                print(document.documentID);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new RequestUpdateDetails(
                              requestDetail: document,
                            )));
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
