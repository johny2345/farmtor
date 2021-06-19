import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmtor/components/userDetails.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of clients'),
      ),
      body: _getUserList(context),
    );
  }

  _getUserList(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .where('isAdmin', isEqualTo: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return _displayUsers(context, snapshot.data);
        }
      },
    );
  }

  _displayUsers(BuildContext context, QuerySnapshot snapshot) {
    var userId;
    return ListView(
      children: snapshot.documents.map((document) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0)),
            child: ListTile(
              leading: Icon(Icons.person),
              title: new Text(document['fName'] + ' ' + document['lName']),
              onTap: () {
                userId = document.documentID;
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            new UserDetailsPage(userDetails: document)));
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
