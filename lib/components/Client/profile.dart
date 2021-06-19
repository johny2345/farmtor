import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmtor/components/Client/updateProfile.dart';

class ProfilePage extends StatefulWidget {
  final userData;
  ProfilePage({Key key, this.userData});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userData;
  var userId;
  var userCData;
  _ProfilePageState({Key key, this.userData});

  @override
  Widget build(BuildContext context) {
    print('prof details');
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
      ),
      body: getUserId(context),

      // _displayProfileDetails(context),
    );
  }

  getUserId(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userId = snapshot.data.uid;
            return getUserData(context);
          } else {
            print('prof details loading');
            return CircularProgressIndicator();
          }
        });
  }

  Widget getUserData(BuildContext context) {
    print('------getUserData-------');
    print(userId);
    return StreamBuilder(
      stream:
          Firestore.instance.collection('users').document(userId).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return _displayProfileDetails(context, snapshot.data);
        } else {
          return Container();
        }
      },
    );
  }

  _displayProfileDetails(BuildContext context, snapshot) {
    userCData = snapshot.data;
    debugPrint('----------USER DATA---------');
    print(userData);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(height: 20),
          Center(
            child: Image.asset('assets/images/farmer.png'),
          ),
          Text(
            userCData['fName'] + ' ' + userCData['lName'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            userCData['phoneNumber'],
            style: TextStyle(fontSize: 15),
          ),
          Container(height: 20),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    userCData['address'],
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )),
          ),
          Container(height: 20),
          ButtonTheme(
            minWidth: 130,
            height: 50,
            child: RaisedButton(
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text("EDIT"),
              textColor: Colors.white,
              color: Colors.green,
              colorBrightness: Brightness.dark,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UpdateProfilePage(
                        userData: userCData, userId: userId)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
