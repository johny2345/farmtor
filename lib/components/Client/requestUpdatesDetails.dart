import 'package:flutter/material.dart';

class RequestUpdateDetails extends StatefulWidget {
  final requestDetail;
  RequestUpdateDetails({Key key, this.requestDetail});
  @override
  _RequestUpdateDetailsState createState() =>
      _RequestUpdateDetailsState(requestDetail: requestDetail);
}

class _RequestUpdateDetailsState extends State<RequestUpdateDetails> {
  _RequestUpdateDetailsState({Key key, this.requestDetail});
  final requestDetail;
  DateTime requestDate;
  String month = '';

  @override
  Widget build(BuildContext context) {
    requestDate = requestDetail['dateSchedule'].toDate();
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Details'),
      ),
      body: _getUpdateDetails(context),
    );
  }

  _getUpdateDetails(BuildContext context) {
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
    if (requestDetail['isAccepted'] == true) {
      return _requestAccepted(context);
    } else {
      return _requestDeclined(context);
    }
  }

  _requestAccepted(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                requestDetail['requestDetail'],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'area: ' + requestDetail['area'],
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Text(
                month +
                    ' ' +
                    requestDate.day.toString() +
                    ', ' +
                    requestDate.year.toString(),
                style: TextStyle(fontSize: 18),
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
            Container(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  _requestDeclined(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                requestDetail['requestDetail'],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Reason: ' + requestDetail['reason'],
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Area: ' + requestDetail['area'],
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Text(
                month +
                    ' ' +
                    requestDate.day.toString() +
                    ', ' +
                    requestDate.year.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.teal[50],
                child: Text(
                  requestDetail['details'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            Container(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
