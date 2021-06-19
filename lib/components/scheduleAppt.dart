import 'package:flutter/material.dart';
import 'package:farmtor/api/apiProvider.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:farmtor/widgets/widgetProperty.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleAppt extends StatefulWidget {
  final userId;
  final userData;
  ScheduleAppt({Key key, this.userId, this.userData});
  @override
  _ScheduleApptState createState() =>
      _ScheduleApptState(userId: userId, userData: userData);
}

class _ScheduleApptState extends State<ScheduleAppt> {
  _ScheduleApptState({Key key, this.userId, this.userData});
  final userId, userData;
  DateTime selectedDate = DateTime.now();
  String _details = '';
  String _area = 'Surigao';
  String _hectares = '';
  var _phoneNum;
  var _fullName;
  bool isAdmin;
  bool isLoading = false;
  String dropdownValue = 'Bad-as';
  String dropdownValueHectares = '';
  String buttonName;
  String appbarName;
  String dialogMessage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController detailsController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 250))))) {
      return true;
    }
    return false;
  }

  TimeOfDay _time = TimeOfDay.now().replacing(minute: 00);

  void _onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      print(_time);
    });
  }

  @override
  void dispose() {
    detailsController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('------------USER DATA INSIDE SCHEDULE APPT-------------');
    _fullName = userData['fName'] + ' ' + userData['lName'];
    print(_fullName);
    _phoneNum = userData['phoneNumber'];
    isAdmin = userData['isAdmin'];
    if (isAdmin == true) {
      print('admin can add');
      setState(() {
        buttonName = 'Add Request';
        appbarName = 'Add Appointment';
        dialogMessage = 'Schedule has been added successfully!';
      });
    } else {
      setState(() {
        buttonName = 'Send Request';
        appbarName = 'Request Appointment';
        dialogMessage = 'Request has been sent successfully!';
      });
    }
    if (isLoading == true) {
      return Material(
          child: Center(
        child: Image.asset(
          'assets/images/unnamed.gif',
          height: 70,
        ),
      ));
    } else {
      return Scaffold(
        appBar: AppBar(title: Text(appbarName)),
        body: SingleChildScrollView(
          child: buildFormArea(context),
        ),
      );
    }
  }

  Widget buildFormArea(BuildContext context) {
    print('--------------USER ID FROM SCHEDULE APPOINTMENT--------------');
    print(userId);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 35.0,
            ),
            Text("${selectedDate.toLocal()}".split(' ')[0],
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () => buildMaterialDatePicker(context),
              child: Text('Select date',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              color: Colors.greenAccent,
            ),
            Text(_time.format(context),
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            RaisedButton(
              color: Colors.greenAccent,
              onPressed: () {
                Navigator.of(context).push(showPicker(
                  context: context,
                  value: _time,
                  onChange: _onTimeChanged,
                ));
              },
              child: Text("Select Time"),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                  //   child: TextFormField(
                  //     validator: (input) {
                  //       if (input.isEmpty) {
                  //         return 'Field required';
                  //       }
                  //     },
                  //     onSaved: (input) => _area = input,
                  //     decoration: InputDecoration(
                  //       counterText: '',
                  //       labelText: 'Enter address',
                  //     ),
                  //     maxLength: 60,
                  //   ),
                  // ),
                  Container(
                    height: 20.0,
                  ),
                  Text(
                    'Municipal covered: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                        // underline:
                        //     Container(height: 2, color: Colors.blue[700]),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            _area = dropdownValue;
                          });
                        },
                        items: <String>[
                          'Bad-as',
                          'Surigao City',
                          'Claver',
                          'Placer',
                          'Sison',
                          'Bacuag',
                          'Gigaguite',
                          'Mahanub',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                  // Padding(
                  //     padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 0),
                  //     child: DropdownButton<String>(
                  //       value: dropdownValueHectares,
                  //       icon: Icon(Icons.arrow_downward),
                  //       iconSize: 24,
                  //       elevation: 16,
                  //       isExpanded: true,
                  //       style: TextStyle(color: Colors.black54, fontSize: 20),
                  //       // underline:
                  //       //     Container(height: 2, color: Colors.blue[700]),
                  //       onChanged: (String newValue) {
                  //         setState(() {
                  //           dropdownValueHectares = newValue;
                  //           _hectares = dropdownValueHectares;
                  //         });
                  //       },
                  //       items: <String>[
                  //         '1',
                  //         '2',
                  //         '3',
                  //         '4',
                  //         '5',
                  //       ].map<DropdownMenuItem<String>>((String value) {
                  //         return DropdownMenuItem<String>(
                  //           value: value,
                  //           child: Text(value),
                  //         );
                  //       }).toList(),
                  //     )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    child: TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Field required";
                        }
                      },
                      onSaved: (input) => _details = input,
                      controller: detailsController,
                      decoration: InputDecoration(
                          counterText: '', labelText: 'How many hectares'),
                      maxLength: 150,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
            ),
            OutlineButton(
              highlightedBorderColor: Colors.blue,
              textColor: Colors.black,
              onPressed: (() {
                debugPrint('Send Request button clicked!');
                // setState(() {
                //   isLoading = true;
                // });
                toSendRequest();
              }),
              padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
              child: Text(buttonName),
            )
          ],
        ),
      ),
    );
  }

  void toSendRequest() async {
    print('Fullname: ' + _fullName);
    print('check area: ' + _area);
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return ApiProvider()
          .addAppointment(_area, _details, _fullName, selectedDate, _time,
              _phoneNum, userId, isAdmin)
          .then((value) {
        debugPrint('---------------CHECK THE RETURN SUCCESS VALUE---------');
        print(value);
        setState(() {
          isLoading = false;
        });
        if (value == true) {
          WidgetProperty().successFailDialog(
              context, dialogMessage, Colors.teal, 'AWESOME');
          detailsController.clear();
        } else {
          WidgetProperty().successFailDialog(
              context, 'Unable to send request', Colors.red[900], 'AWESOME');
        }
      });
    }
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        selectableDayPredicate: _decideWhichDayToEnable,
        helpText: 'Select booking date',
        cancelText: 'Not now',
        confirmText: 'Book',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter date in valid range',
        fieldHintText: 'Month/Date/Year',
        builder: (context, child) {
          return Theme(
            data: ThemeData.light(),
            child: child,
          );
        });
    if (picked != null && picked != selectedDate) {
      setState(() {
        DateTime sample =
            DateTime(picked.year, picked.month, picked.day, 0, 0, 0, 0, 0);
        selectedDate = picked;
        debugPrint('----------------');
        print(sample);
      });
    }
  }
}
