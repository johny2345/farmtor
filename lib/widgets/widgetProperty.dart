import 'package:flutter/material.dart';
import 'package:farmtor/api/apiProvider.dart';
import 'package:farmtor/api/apiProvider.dart';

class WidgetProperty {
  loadingProgress(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> invalidDialog(BuildContext context, title, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                    child: RaisedButton(
                  color: Colors.blue,
                  // highlightedBorderColor: Colors.teal,
                  textColor: Colors.white,
                  child: Text('OK'),
                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  onPressed: () {
                    print(
                        '------------HAS CLICKED INVALID EMAIL/PASSWORD!--------');
                    Navigator.of(context).pop();
                  },
                ))
              ],
            ),
          ],
        );
      },
    );
  }

  isCreatedSuccessfully(BuildContext context, title, message) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 250.0,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                        ),
                        child: Center(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  RaisedButton(
                    child: Text('Awesome'),
                    textColor: Colors.black,
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    onPressed: () {
                      Navigator.pop(context);
                      ApiProvider().signOut();
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => UploadImage(),
                      //     ));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  accIsCreatedSuccefully(BuildContext context, title, message) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 250.0,
              width: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 150.0,
                    ),
                    Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                        color: Colors.teal,
                      ),
                      child: Center(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OutlineButton(
                      child: Text("Okay"),
                      textColor: Colors.black54,
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      borderSide: BorderSide(color: Colors.blue),
                      onPressed: () {
                        Navigator.pop(context);
                        ApiProvider().signOut();
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomeScreen()));
                      },
                    ),
                  ],
                ),
              ]),
            ),
          );
        });
  }

  successFailDialog(
      BuildContext context, message, backgroundColor, buttonMes) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 250.0,
              width: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 150.0,
                    ),
                    Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                          color: backgroundColor),
                      child: Center(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        child: Text(buttonMes),
                        textColor: Colors.white,
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ]),
            ),
          );
        });
  }

  verifyDialog(BuildContext context, apptDetails) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 250.0,
              width: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 150.0,
                    ),
                    Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                          color: Colors.teal),
                      child: Center(
                        child: Text(
                          'Are you sure you want to delete this?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        child: Text('DELETE'),
                        textColor: Colors.white,
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        onPressed: () {
                          ApiProvider()
                              .deleteAppt(apptDetails.documentID)
                              .then((value) {
                            print('DETERMINE THE VALUE TO REMOVE');
                            print(value);
                          });
                          Navigator.pop(context);
                          WidgetProperty().successFailDialog(
                              context,
                              'The appointment has been removed successfully',
                              Colors.teal,
                              'AWESOME');

                          return true;
                        }),
                    RaisedButton(
                        child: Text('CANCEL'),
                        textColor: Colors.white,
                        color: Colors.red[700],
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        onPressed: () {
                          Navigator.pop(context);
                          // return false;
                        }),
                  ],
                ),
              ]),
            ),
          );
        });
  }
}
