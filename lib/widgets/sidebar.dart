import 'package:farmtor/components/calendarPage.dart';
import 'package:farmtor/components/scheduleAppt.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:farmtor/components/aboutUs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmtor/api/apiProvider.dart';
import 'package:farmtor/components/login.dart';
import 'package:farmtor/components/request.dart';
import 'package:farmtor/components/usersList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmtor/components/Client/client.dart';
import 'package:farmtor/components/listOfAppt.dart';

class Sidebar extends StatefulWidget {
  Sidebar({Key key});

  @override
  _SidebarState createState() => _SidebarState();
}

dynamic userData;

class _SidebarState extends State<Sidebar> {
  _SidebarState({Key key});
  var userId;
  FSBStatus drawerStatus;
  // dynamic userData;

  dynamic dataGenerated = null;

  @override
  Widget build(BuildContext context) {
    if (dataGenerated != null) {
      print('DATA GENERATED HAS DATA!');
      print(dataGenerated.data);
      return createSidebarUI(context, dataGenerated.data);
    }
    return getUserId(context);
  }

  getUserId(BuildContext context) {
    print('---------SIDEBAR GENERATED-----------');
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userId = snapshot.data.uid;
            return getUserDetails(context);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  getUserDetails(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('users').document(userId).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          dataGenerated = snapshot;
          return createSidebarUI(context, snapshot.data);
        } else {
          return Material(
              child: Center(
            child: Image.asset(
              'assets/images/unnamed.gif',
              height: 70,
            ),
          ));
        }
      },
    );
  }

  // verifyUserCreds(BuildContext context) {

  // }

  createSidebarUI(BuildContext context, snapshot) {
    debugPrint('-------snapshot------------');
    print(snapshot.data);
    userData = snapshot.data;
    print(userData['phoneNumber']);
    print('phoneNumber');
    if (userData['isAdmin'] == true) {
      return SafeArea(
        child: Scaffold(
          body: SwipeDetector(
            onSwipeRight: (() {
              setState(() {
                drawerStatus = FSBStatus.FSB_OPEN;
              });
            }),
            onSwipeLeft: (() {
              setState(() {
                drawerStatus = FSBStatus.FSB_CLOSE;
              });
            }),
            child: FoldableSidebarBuilder(
              drawerBackgroundColor: Colors.deepOrange,
              drawer: AdminCustomDrawer(
                userId: userId,
                closeDrawer: () {
                  setState(() {
                    drawerStatus = FSBStatus.FSB_CLOSE;
                  });
                },
              ),
              screenContents: AboutUsPage(),
              status: drawerStatus,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepOrange,
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: (() {
              setState(() {
                drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
                    ? FSBStatus.FSB_CLOSE
                    : FSBStatus.FSB_OPEN;
                ;
              });
            }),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          body: SwipeDetector(
            onSwipeRight: (() {
              setState(() {
                drawerStatus = FSBStatus.FSB_OPEN;
              });
            }),
            onSwipeLeft: (() {
              setState(() {
                drawerStatus = FSBStatus.FSB_CLOSE;
              });
            }),
            child: FoldableSidebarBuilder(
              drawerBackgroundColor: Colors.deepOrange,
              drawer: ClientPage(
                userId: userId,
                userData: userData,
                closeDrawer: () {
                  setState(() {
                    drawerStatus = FSBStatus.FSB_CLOSE;
                  });
                },
              ),
              screenContents: AboutUsPage(),
              status: drawerStatus,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepOrange,
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: (() {
              setState(() {
                drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
                    ? FSBStatus.FSB_CLOSE
                    : FSBStatus.FSB_OPEN;
                ;
              });
            }),
          ),
        ),
      );
    }
  }
}

class AdminCustomDrawer extends StatelessWidget {
  final Function closeDrawer;
  final userId;
  const AdminCustomDrawer({Key key, this.closeDrawer, this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ScheduleAppt(userId: userId, userData: userData)));
            },
            leading: Icon(Icons.schedule),
            title: Text(
              "Add Appointment",
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => RequestPage()));
            },
            leading: Icon(Icons.local_activity),
            title: Text("Request"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserListPage()));
            },
            leading: Icon(Icons.person),
            title: Text('Clients'),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ListOfApptPage()));
            },
            leading: Icon(Icons.person),
            title: Text('Schedules'),
          ),
          // Divider(
          //   height: 1,
          //   color: Colors.grey,
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (context) => Sample()));
          //   },
          //   leading: Icon(Icons.details),
          //   title: Text("About Us"),
          // ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              ApiProvider().signOut().then((val) {
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
