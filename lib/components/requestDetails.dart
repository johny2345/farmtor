import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmtor/widgets/widgetProperty.dart';

class RequestDetailPage extends StatefulWidget {
  var requestDetail;
  RequestDetailPage({Key key, this.requestDetail});
  @override
  _RequestDetailPageState createState() =>
      _RequestDetailPageState(requestDetail: requestDetail);
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  var requestDetail;
  var requestUserId;
  String reason;
  _RequestDetailPageState({Key key, this.requestDetail});
  TextEditingController reasonController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    requestUserId = requestDetail['userId'];
    debugPrint('-----REQUEST DETAILS--------');
    print(requestDetail.documentID);
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
      ),
      body: _displayRequestDetails(context),
    );
  }

  _acceptProposal() async {
    var color = Colors.teal;
    try {
      await Firestore.instance.runTransaction((transaction) async {
        DocumentReference postRef = Firestore.instance
            .collection('users')
            .document('g0qNuyJB2tbRsolH1OJB31RBDYj2')
            .collection('schedules')
            .document(requestDetail.documentID);
        // DocumentSnapshot snapshot = await transaction.get(postRef);
        await transaction.update(postRef, {'isApproved': true}).then((value) {
          Firestore.instance
              .collection("users")
              .document(requestUserId)
              .collection('request')
              .add({
            "reason": '',
            "requestDetail": 'Your request for service has been accepted.',
            "area": requestDetail['area'],
            "details": requestDetail['details'],
            "dateSchedule": requestDetail["dateSchedule"],
            "isAccepted": true,
          });
        });
        WidgetProperty().successFailDialog(context,
            'The request has been approved successfully', color, 'AWESOME');
        return true;
      });

      WidgetProperty().successFailDialog(
          context, 'The request has failed to update', Colors.red, 'OKAY');
      return false;
    } catch (e) {
      print(e.toString());
    }
  }

  _declineProposal() async {
    debugPrint('------DECLINE REQUEST-------');
    print(requestUserId);
    print(reasonController.text);
    reason = reasonController.text;
    try {
      debugPrint('------DECLINE REQUEST-------');
      print(reasonController.text);
      Firestore.instance.runTransaction((transaction) async {
        DocumentReference postRef = Firestore.instance
            .collection('users')
            .document('g0qNuyJB2tbRsolH1OJB31RBDYj2')
            .collection('schedules')
            .document(requestDetail.documentID);
        // DocumentSnapshot snapshot = await transaction.get(postRef);
        await transaction.update(postRef, {'isApproved': null});
      }).then((value) {
        Firestore.instance
            .collection("users")
            .document(requestUserId)
            .collection('request')
            .add({
          "reason": reason.toString(),
          "requestDetail": 'Your request for service has been denied.',
          "area": requestDetail['area'],
          "dateSchedule": requestDetail["dateSchedule"],
          'details': requestDetail['details'],
          "isAccepted": false,
        }).then((value) {
          WidgetProperty().successFailDialog(
              context, 'The request has been declined', Colors.teal, 'OKAY');
          reason = '';
        });
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  _displayRequestDetails(BuildContext context) {
    debugPrint('-------------GET DATE------------');
    String month = '';
    DateTime requestDate = requestDetail['dateSchedule'].toDate();
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
    print(requestDate);
    // String date =
    //     requestDate.year.toString() + '' + requestDate.month.toString();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              requestDetail['appointee'],
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                requestDetail['area'],
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                month +
                    ' ' +
                    requestDate.day.toString() +
                    ', ' +
                    requestDate.year.toString(),
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.teal[50],
                child: Text(
                  requestDetail['details'],
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  child: RaisedButton(
                      textColor: Colors.white,
                      child: Text('ACCEPT'),
                      onPressed: () {
                        _acceptProposal();
                      },
                      padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                      color: Colors.green[700]),
                ),
                RaisedButton(
                    textColor: Colors.white,
                    child: Text('DECLINE'),
                    onPressed: () {
                      _reasonDialog(context);
                    },
                    padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                    color: Colors.red[700]),
              ],
            )
          ],
        ),
      ),
    );
  }

  _reasonDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 300.0,
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 100.0,
                      ),
                      Container(
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                          color: Colors.teal,
                        ),
                        child: Center(
                          child: Text(
                            "Are you sure? (state you reason)",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 1.0, 30.0, 10.0),
                        child: TextFormField(
                          maxLength: 50,
                          controller: reasonController,
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                            labelText: '',
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please enter member\'s name";
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.green,
                              textColor: Colors.white,
                              onPressed: () {
                                _declineProposal();
                                reasonController.clear();
                                Navigator.of(context).pop();
                              },
                              padding: EdgeInsets.fromLTRB(55, 10, 55, 10),
                              child: Text('CONFIRM'),
                              splashColor: Colors.deepOrange,
                            ),
                            RaisedButton(
                              color: Colors.red,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                                reasonController.clear();
                              },
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text('CANCEL'),
                              splashColor: Colors.deepOrange,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        });
  }
}
