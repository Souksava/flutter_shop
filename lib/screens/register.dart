import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_shop/screens/my_service.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Explicit
  final formkey = GlobalKey<FormState>();
  String name, email, password;
  //Method
  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('Your Click Upload');
        if (formkey.currentState.validate()) {
          formkey.currentState.save();
          print('name = $name, email = $email, password = $password');
          registerThread();
        }
      },
    );
  }

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((response) {
      print('Register Success for Email = $email');
      setupDisplayName();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('title = $title, message = $message');
      myAlert(title, message);
    });
  }

  Future<void> setupDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.currentUser().then((response) {
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      response.updateProfile(userUpdateInfo);
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Myservice());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.error,
                color: Colors.red,
                size: 48.0,
              ),
              title: Text(
                title,
                style: TextStyle(color: Colors.red),
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget nameText() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        icon: Icon(
          Icons.person,
          color: Colors.red,
          size: 48.0,
        ),
        labelText: 'ຊື່ຜູ້ໃຊ້',
        labelStyle: TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSansLao',
          fontSize: 14.0,
        ),
        helperText: 'type Your Nick Name',
        helperStyle: TextStyle(
          color: Colors.purple,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Fill Your Name in the Blank';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        name = value.trim();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        icon: Icon(
          Icons.email,
          color: Colors.red,
          size: 48.0,
        ),
        labelText: 'ອີເມວຜູ້ໃຊ້',
        labelStyle: TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSansLao',
          fontSize: 14.0,
        ),
        helperText: 'type Your email',
        helperStyle: TextStyle(
          color: Colors.purple,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (!((value.contains('@')) && (value.contains('.')))) {
          return 'Please type Email Exp. you@email.com';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        email = value.trim();
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: Colors.red,
          size: 48.0,
        ),
        labelText: 'ລະຫັດຜູ້ໃຊ້',
        labelStyle: TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSansLao',
          fontSize: 14.0,
        ),
        helperText: 'type Your Password',
        helperStyle: TextStyle(
          color: Colors.purple,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (value.length < 6) {
          return 'Password More 6 Charactor';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        password = value.trim();
      },
    );
  }

  // Widget singUpButton() {
  //   return RaisedButton(
  //     color: Colors.blue.shade700,
  //     child: Text(
  //       'ເຂົ້າສູ່ລະບົບ',
  //       style: TextStyle(color: Colors.white, fontFamily: 'NotoSansLao'),
  //     ),
  //     onPressed: () {
  //       print('Your Click Sign Up');
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue.shade800,
        title: Text('Register'),
        actions: <Widget>[registerButton()],
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            nameText(),
            emailText(),
            passwordText(),
            // SizedBox(
            //   height: 10.0,
            // ),
            // singUpButton(),
          ],
        ),
      ),
    );
  }
}
