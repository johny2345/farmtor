import 'package:flutter/material.dart';
import 'package:farmtor/widgets/widgetProperty.dart';

class ApptDetailsPage extends StatefulWidget {
  final apptDetails;
  ApptDetailsPage({Key key, this.apptDetails});

  @override
  _ApptDetailsPageState createState() =>
      _ApptDetailsPageState(apptDetails: apptDetails);
}

class _ApptDetailsPageState extends State<ApptDetailsPage> {
  _ApptDetailsPageState({Key key, this.apptDetails});
  final apptDetails;
  String month = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Details'),
      ),
      body: _displayScheduleDetails(context),
    );
  }

  Widget _displayScheduleDetails(BuildContext context) {
    DateTime requestDate = apptDetails['dateSchedule'].toDate();
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

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              apptDetails['appointee'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                apptDetails['area'],
                style: TextStyle(fontSize: 25),
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
                  apptDetails['details'],
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: RaisedButton(
                  textColor: Colors.white,
                  child: Text('DELETE'),
                  onPressed: () {
                    WidgetProperty()
                        .verifyDialog(context, apptDetails)
                        .then((value) {
                      debugPrint('----Received the value------');
                      print(value);
                      // if (value == null) {
                      //   WidgetProperty().successFailDialog(
                      //       context,
                      //       'The appointment has been removed successfully',
                      //       Colors.teal,
                      //       'AWESOME');
                      // } else {
                      // WidgetProperty().successFailDialog(
                      //     context,
                      //     'The appointment has been failed to remove',
                      //     Colors.red[900],
                      //     'OKAY');
                      // }
                    });
                  },
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                  color: Colors.green[700]),
            ),
          ],
        ),
      ),
    );
  }
}
