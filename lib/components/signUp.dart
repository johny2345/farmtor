import 'package:flutter/material.dart';
import 'package:farmtor/widgets/widgetProperty.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmtor/api/apiProvider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePass = true;

  FirebaseUser user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  var _visible = Icon(Icons.visibility);

  String _email, _password, userId;
  String _firstName, _lastName, _address;
  num _phoneNum;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool _isWait = false;

  @override
  Widget build(BuildContext context) {
    print(_isWait);
    print('----------IS LOADING-----------------');
    if (_isWait) {
      return Material(
          child: Center(
        child: Image.asset(
          'assets/images/unnamed.gif',
          height: 70,
        ),
      ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 20.0,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/unnamed.gif',
                      width: 300.0,
                      height: 200,
                    ),
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide an email';
                      }
                    },
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Enter email',
                      icon: new Icon(Icons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Input password';
                      }
                    },
                    onSaved: (input) => _password = input,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Confirm password',
                      icon: new Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: _visible,
                        onPressed: () {
                          if (_obscurePass == true) {
                            setState(() {
                              _obscurePass = false;
                              _visible = Icon(Icons.visibility_off);
                            });
                          } else {
                            setState(() {
                              _visible = Icon(Icons.visibility);
                              _obscurePass = true;
                            });
                          }
                        },
                      ),
                    ),
                    obscureText: _obscurePass,
                    maxLength: 50,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Field required';
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Enter first name',
                      icon: new Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 15,
                    controller: firstNameController,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Field required';
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Enter last name',
                      icon: new Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.text,
                    maxLength: 15,
                    controller: lastNameController,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Field required';
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Enter phone number',
                      icon: new Icon(Icons.confirmation_number),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    controller: phoneController,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Field required';
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Enter address',
                      icon: new Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    controller: addressController,
                  ),
                  new Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  new OutlineButton(
                    borderSide: BorderSide(color: Colors.blue[300]),
                    highlightedBorderColor: Colors.teal,
                    textColor: Colors.black54,
                    onPressed: () {
                      signUp();
                    },
                    padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                    child: Text('SIGN UP'),
                    splashColor: Colors.deepOrange,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Future signUp() async {
    print('SIGN UP CALLED-------');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('validated form');
      setState(() {
        print('IS WAIT TO TRUE-------------------');
        _isWait = true;
      });
      try {
        user = (await _firebaseAuth.createUserWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        userId = user.uid;
        print('created user');
        if (user != null) {
          // await user.sendEmailVerification();
          await farmerDetails();
          setState(() {
            print('IS WAIT TO FALSE-------------------');
            _isWait = false;
          });
          ApiProvider().signOut();
        }
      } catch (signUpError) {
        setState(() {
          _isWait = false;
        });
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          WidgetProperty().invalidDialog(context, 'EMAIL ALREADY EXIST',
              "Email already in use, please use another");
        }
      }
    } else {
      setState(() {
        _isWait = false;
      });
      WidgetProperty().accIsCreatedSuccefully(
          context,
          "ACCOUNT CREATED SUCCESSFULLY",
          "Account created successfully, you are now able to login to this account");
      print('not validated form');
    }
  }

  Future farmerDetails() async {
    print('---------------STUDENT CREATE-------------');
    _firstName = firstNameController.text;
    _lastName = lastNameController.text;

    String toCamelCaseFName =
        _firstName[0].toUpperCase() + _firstName.substring(1).toString();
    String toCamelCaseLName =
        _lastName[0].toUpperCase() + _lastName.substring(1).toString();

    try {
      await Firestore.instance.runTransaction((transaction) async {
        DocumentReference postRef =
            Firestore.instance.collection('users').document(userId);
        Firestore.instance.collection("users").document(userId).setData({
          'fName': toCamelCaseFName,
          'lName': toCamelCaseLName,
          'phoneNumber': phoneController.text,
          'address': addressController.text,
          'isAdmin': false
        }).then((value) {});
      });
      setState(() {
        _isWait = false;
      });
      firstNameController.clear();
      lastNameController.clear();
      addressController.clear();
      phoneController.clear();
      WidgetProperty().accIsCreatedSuccefully(
          context,
          "ACCOUNT CREATED SUCCESSFULLY",
          "Account created successfully, you are now able to login to this account");
    } catch (e) {
      print(e.toString());
    }
  }
}
