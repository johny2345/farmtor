import 'package:flutter/material.dart';
import 'package:farmtor/components/apptDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListOfApptPage extends StatefulWidget {
  @override
  _ListOfApptPageState createState() => _ListOfApptPageState();
}

class _ListOfApptPageState extends State<ListOfApptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules'),
      ),
      body: _getListOfAppt(context),
    );
  }

  Widget _getListOfAppt(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document('g0qNuyJB2tbRsolH1OJB31RBDYj2')
            .collection('schedules')
            .where('isApproved', isEqualTo: true)
            .orderBy('dateSchedule')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return _displayAppt(context, snapshot.data);
          } else {
            return Center(
              child: Image.asset(
                'assets/images/unnamed.gif',
                height: 70,
              ),
            );
          }
        });
  }

  Widget _displayAppt(BuildContext context, QuerySnapshot snapshot) {
    String month = '';
    return ListView(
      children: snapshot.documents.map((document) {
        DateTime requestDate = document['dateSchedule'].toDate();
        if (requestDate.month == 1) {
          month = 'January';
        } else if (requestDate.month == 2) {
          month = 'February';
        } else if (requestDate.month == 3) {
          month = 'March';
        } else if (requestDate.month == 4) {
          month = 'April';
        } else if (requestDate.month == 5) {
          month = 'May';
        } else if (requestDate.month == 6) {
          month = 'June';
        } else if (requestDate.month == 7) {
          month = 'July';
        } else if (requestDate.month == 8) {
          month = 'August';
        } else if (requestDate.month == 9) {
          month = 'September';
        } else if (requestDate.month == 10) {
          month = 'October';
        } else if (requestDate.month == 11) {
          month = 'November';
        } else if (requestDate.month == 12) {
          month = 'December';
        }
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0)),
            child: ListTile(
              leading: Icon(Icons.schedule),
              subtitle: Text(month.toString() +
                  ' ' +
                  requestDate.day.toString() +
                  ',' +
                  ' ' +
                  requestDate.year.toString()),
              title: new Text(document['appointee']),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ApptDetailsPage(apptDetails: document)));
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
