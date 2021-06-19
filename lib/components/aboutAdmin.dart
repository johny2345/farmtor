import 'package:flutter/material.dart';

class AboutAdminPage extends StatelessWidget {
  const AboutAdminPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: displayAdminDesc(context),
    );
  }

  displayAdminDesc(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Image.asset(
              'assets/images/admin.jpg',
              fit: BoxFit.contain,
              // height: 200.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Tractor Owner',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 20,
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              height: 20,
            ),
            Text(
              'MARIBETH G. EQUIPILAG',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              'Brgy. Tinogpahan P3. Sison, Surigao Del Norte',
              textAlign: TextAlign.center,
            ),
            Text('09078134026'),
            Container(
              height: 20.0,
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              height: 20,
            ),
            Text(
              'OPERATOR',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              'ROBERTO C. GUIRAL',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Brgy. Quezon Purok Narra B. Surigao City, Surigao Del Norte',
                textAlign: TextAlign.center),
            Text('09097362177'),
            SizedBox(
              height: 20.0,
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Service price: 400 Pesos per hour',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.green[900]),
            ),
          ],
        ),
      ),
    );
  }
}
