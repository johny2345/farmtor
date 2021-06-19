import 'package:flutter/material.dart';
import 'package:farmtor/api/apiProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmtor/widgets/widgetProperty.dart';

class UpdateProfilePage extends StatefulWidget {
  final userData;
  final userId;
  UpdateProfilePage({Key key, this.userData, this.userId});

  @override
  _UpdateProfilePageState createState() =>
      _UpdateProfilePageState(userData: userData, userId: userId);
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final userData;
  final userId;
  _UpdateProfilePageState({Key key, this.userData, this.userId});

  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool toEnableTextfield = true;
  // var uid = userData.;

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    phoneController.text = userData['phoneNumber'];
    addressController.text = userData['address'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: _buildForm(context),
    );
  }

  _buildForm(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 30.0,
            ),
            Text(
              userData['fName'] + ' ' + userData['lName'],
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Provide a phone number';
                    }
                  },
                  enabled: toEnableTextfield,
                  controller: phoneController,
                  decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                      labelText: 'Enter your phone number'),
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 50.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Provide your address';
                    }
                  },
                  enabled: toEnableTextfield,
                  controller: addressController,
                  decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                      labelText: 'Enter your address'),
                )),
            ButtonTheme(
              minWidth: 130,
              height: 50,
              child: RaisedButton(
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: Text("UPDATE"),
                textColor: Colors.white,
                color: Colors.green,
                colorBrightness: Brightness.dark,
                onPressed: () {
                  updateProfile();
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> updateProfile() async {
    print('userid: ' + userId);
    print(phoneController.text);
    print(addressController.text);
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await Firestore.instance.runTransaction((transaction) async {
          DocumentReference postRef =
              Firestore.instance.collection('users').document(userId);
          await transaction.update(postRef, {
            'phoneNumber': phoneController.text,
            'address': addressController.text
          });
        }).then((value) {
          print('profile updatec successfully');
          WidgetProperty().successFailDialog(
              context, 'Profile updated successfully', Colors.teal, 'AWESOME');
        });
        return true;
      } catch (e) {
        return false;
      }
    }
  }
}
