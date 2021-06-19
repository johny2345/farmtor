import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:farmtor/api/apiProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  dynamic appointment, date, element;
  dynamic meetings = <Meeting>[];
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document('g0qNuyJB2tbRsolH1OJB31RBDYj2')
            .collection('schedules')
            .where('isApproved', isEqualTo: true)
            // .where('isAdmin', isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return initializeCalendarUI(context, snapshot.data);
          }
          return Center(
            child: Image.asset(
              'assets/images/unnamed.gif',
              height: 70,
            ),
          );
        });
  }

  initializeCalendarUI(BuildContext context, snapshot) {
    DateTime schedule;
    Timestamp stamp;
    List<DocumentSnapshot> templist = snapshot.documents;
    List<Map<dynamic, dynamic>> list = new List();
    list = templist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data;
    }).toList();
    meetings = <Meeting>[];
    debugPrint('PRINT EACH LIST-------');
    list.forEach((element) {
      String client = element['appointee'];
      String details = element['details'];
      String area = element['area'];
      String combine = area + ' - ' + client;
      stamp = element['dateSchedule'];
      schedule = stamp.toDate();
      print(element['appointee'] +
          ' - ' +
          schedule.month.toString() +
          ' ' +
          schedule.day.toString());
      var dateSched = DateTime.utc(
          schedule.year, schedule.month, schedule.day, schedule.hour, 0, 0);
      var endSched = dateSched.add(const Duration(hours: 8));
      meetings.add(Meeting(combine, details, client, dateSched, endSched,
          const Color(0xFF0F8644), false));
    });
    debugPrint('PRINT EACH LIST-------');
    print(list);
    return Scaffold(
      appBar: AppBar(title: Text('Calendar')),
      body: SfCalendar(
        view: CalendarView.month,
        todayHighlightColor: Colors.red,
        dataSource: MeetingDataSource(_getDataSource(snapshot)),
        monthViewSettings: MonthViewSettings(showAgenda: true),
      ),
    );
  }

  List<Meeting> _getDataSource(QuerySnapshot snapshot) {
    debugPrint('----------APPOINTEE------------------');

    final DateTime today = DateTime.now();
    // print(today);
    var dateSched = DateTime.utc(2021, 01, 01, 3, 5, 0);
    var endSched = DateTime.utc(2021, 01, 02, 3, 0, 0);
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    // meetings.add(Meeting(
    //     'Surigao Area tortol',
    //     'Manang Sonya',
    //     'Pa tortol sa iya basakan',
    //     startTime,
    //     endTime,
    //     const Color(0xFF0F8644),
    //     false));

    // meetings.add(Meeting(snapshot.data))
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.client, this.details, this.from, this.to,
      this.background, this.isAllDay);

  String eventName;
  String client;
  String details;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
