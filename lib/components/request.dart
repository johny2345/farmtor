import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmtor/components/requestDetails.dart';

class RequestPage extends StatefulWidget {
  RequestPage({Key key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Request'),
      ),
      body: _getRequest(context),
    );
  }

  Widget _getRequest(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document('g0qNuyJB2tbRsolH1OJB31RBDYj2')
          .collection('schedules')
          // .where('isAdmin', isEqualTo: false)
          .where('isApproved', isEqualTo: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container(
              child: Center(
            child: Text('No data available'),
          ));
        } else {
          return _displayRequests(context, snapshot.data);
        }
      },
    );
  }

  Widget _displayRequests(BuildContext context, QuerySnapshot snapshot) {
    print('--------------SNAPSHOT REQUEST-----------');
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
              title: new Text(document['appointee']),
              onTap: () {
                print('--------------DOCUMENT ID: -------------------------');
                print(document.documentID);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new RequestDetailPage(
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
