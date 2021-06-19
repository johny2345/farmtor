import 'package:farmtor/components/calendarPage.dart';
import 'package:farmtor/components/scheduleAppt.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:farmtor/components/Client/requestUpdates.dart';
import 'package:farmtor/api/apiProvider.dart';
import 'package:farmtor/components/login.dart';
import 'package:farmtor/components/Client/profile.dart';
import 'package:farmtor/components/aboutAdmin.dart';
// import 'package:farmtor/components/request.dart';
// import 'package:farmtor/components/usersList.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class ClientPage extends StatelessWidget {
  final Function closeDrawer;
  final userId;
  final userData;
  const ClientPage({Key key, this.closeDrawer, this.userId, this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPrint('----------CLIENT MODULE USER DATA---------');
    // print(userData);
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      color: Colors.white,
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey.withAlpha(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: mediaQuery.size.width * 0.60,
                    height: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image:
                                new ExactAssetImage('assets/images/farm.jpg'))),
                    child: Image.asset('assets/images/farm.jpg'),
                    // fit: BoxFit.,
                  ),
                  // Text("RetroPortal Studio")
                ],
              )),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              closeDrawer();
              debugPrint("Tapped Schedule");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ScheduleAppt(userId: userId, userData: userData)));
            },
            leading: Icon(Icons.schedule),
            title: Text(
              "Schedule Appointment",
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CalendarPage()));
              closeDrawer();
            },
            leading: Icon(Icons.calendar_view_day),
            title: Text("Calendar"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RequestUpdatePage()));
            },
            leading: Icon(Icons.local_activity),
            title: Text("Updates"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              debugPrint('----------CLIENT MODULE USER DATA---------');
              print(userData);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(userData: userData)));
            },
            leading: Icon(Icons.person),
            title: Text("Profile"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AboutAdminPage()));
            },
            leading: Icon(Icons.details),
            title: Text("About Us"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              ApiProvider().signOut().then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
                debugPrint("Tapped Log Out");
              });
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
