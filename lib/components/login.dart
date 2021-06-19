import 'package:farmtor/widgets/widgetProperty.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmtor/widgets/sidebar.dart';
import 'package:farmtor/api/apiProvider.dart';
import 'package:farmtor/components/signUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;
  var _iconVisible = Icon(Icons.visibility);
  String _email, _password;
  var userId;
  FirebaseUser user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  @override
  void initState() {
    getUser().then((user) {
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Sidebar()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ApiProvider().signOut();
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
        appBar: AppBar(
          title: Text('FarmTor'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please provide an email';
                            }
                          },
                          onSaved: (input) => _email = input,
                          decoration: InputDecoration(
                              counterText: '',
                              labelText: 'Enter email',
                              icon: new Icon(Icons.mail)),
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 30),
                      TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Input password';
                          }
                        },
                        onSaved: (input) => _password = input,
                        decoration: InputDecoration(
                          counterText: '',
                          labelText: 'Password',
                          icon: new Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: _iconVisible,
                            onPressed: () {
                              if (_obscureText == true) {
                                setState(() {
                                  _obscureText = false;
                                  _iconVisible = Icon(Icons.visibility_off);
                                });
                              } else {
                                setState(() {
                                  _iconVisible = Icon(Icons.visibility);
                                  _obscureText = true;
                                });
                              }
                            },
                          ),
                        ),
                        obscureText: _obscureText,
                        maxLength: 30,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                      ),
                      new OutlineButton(
                        // highlightedBorderColor: Colors.deepOrange,
                        borderSide: BorderSide(color: Colors.blue[300]),
                        onPressed: () {
                          toSignIn();
                        },
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                        child: Text('LOGIN'),
                        splashColor: Colors.deepOrange,
                      ),
                      new Padding(padding: const EdgeInsets.only(top: 20.0)),
                      new Text('Don\'t have an account?'),
                      new InkWell(
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        onTap: () {
                          print(
                              '--------------SIGN UP BUTTON CLICKED-----------');
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SignUp()));
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> toSignIn() async {
    print('email: ' + _email.toString());
    print('password: ' + _password.toString());
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        setState(() {
          isLoading = true;
        });
        user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        var userId = user.uid;
        setState(() {
          isLoading = false;
        });

        if (user != null) {
          setState(() {
            isLoading = false;
          });
          print('-------------THE USER HAS LOGGED IN-----------------------');
          print(user.uid);
          // return getUserData(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Sidebar()));
        }
      } catch (signUpError) {
        setState(() {
          isLoading = false;
        });
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          WidgetProperty().invalidDialog(context, 'INVALID EMAIL OR PASSWORD',
              'The username or password might already exist.');
        }
        print(signUpError);
        WidgetProperty().invalidDialog(context, 'INVALID PASSWORD',
            'This email or password might not exist');
      }
    }
  }

  getUserData(BuildContext context) {
    print('-------------get user data-----------------------');
    return StreamBuilder<DocumentSnapshot>(
      stream:
          Firestore.instance.collection('users').document(userId).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        print(snapshot);
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data['isAdmin'] == true) {
            debugPrint('-----------PROFILE IS ADMIN---------');
            ApiProvider().signOut();
          } else {
            debugPrint('------------IS NOT ADMIN-----------');
            ApiProvider().signOut();
          }
          // return userDescription(context, snapshot.data);
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Text('User does not exist');
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

// class VerifyUser extends StatefulWidget {
//   @override
//   _VerifyUserState createState() => _VerifyUserState();
// }

// class _VerifyUserState extends State<VerifyUser> {
//   var userId;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: FirebaseAuth.instance.currentUser(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             userId = snapshot.data.uid;
//             return getUserData(context);
//           } else {
//             return Material(
//                 child: Center(
//               child: Image.asset(
//                 'assets/images/unnamed.gif',
//                 height: 70,
//               ),
//             ));
//           }
//         });
//   }

//   getUserData(BuildContext context) {
//     print('-------------get user data-----------------------');
//     return Scaffold(
//       body: StreamBuilder<DocumentSnapshot>(
//         stream:
//             Firestore.instance.collection('users').document(userId).snapshots(),
//         builder:
//             (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           print(snapshot);
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (snapshot.connectionState == ConnectionState.active) {
//             if (snapshot.data['isAdmin'] == true) {
//               debugPrint('-----------PROFILE IS ADMIN---------');
//               Navigator.pushReplacement(
//                   context, MaterialPageRoute(builder: (context) => Sidebar()));
//             } else {
//               debugPrint('------------IS NOT ADMIN-----------');
//               ApiProvider().signOut();
//             }
//             // return userDescription(context, snapshot.data);
//           } else if (snapshot.connectionState == ConnectionState.none) {
//             return Text('User does not exist');
//           }
//           return Material(
//               child: Center(
//             child: Image.asset(
//               'assets/images/unnamed.gif',
//               height: 70,
//             ),
//           ));
//         },
//       ),
//     );
//   }
// }
