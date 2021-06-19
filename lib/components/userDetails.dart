import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  final userDetails;
  UserDetailsPage({Key key, this.userDetails}) : super(key: key);

  @override
  _UserDetailsPageState createState() =>
      _UserDetailsPageState(userDetails: userDetails);
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final userDetails;
  _UserDetailsPageState({Key key, this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: _displayUserDetails(context),
    );
  }

  _displayUserDetails(BuildContext context) {
    String fullName = userDetails['fName'] + ' ' + userDetails['lName'];
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              fullName.toString(),
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              userDetails['phoneNumber'].toString(),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      userDetails['address'],
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
