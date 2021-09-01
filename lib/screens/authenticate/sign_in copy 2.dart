import 'package:flutter/material.dart';
import 'package:tassie/utilities/auth.dart';
import '../../constants.dart';

class SignInC2 extends StatefulWidget {
  final Function? func;
  SignInC2({this.func});
  @override
  _SignInC2State createState() => _SignInC2State();
}

class _SignInC2State extends State<SignInC2> {
  final AuthUtil _auth = AuthUtil();
  String password = "";
  String email = "";
  String error = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkFields() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kTextWhite,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/photos/appbar-bg-lg.png",
                fit: BoxFit.fitWidth),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/photos/abstract2.png",
                fit: BoxFit.fitWidth),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.15,
                  ),
                  Container(
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Text(
                      'Welcome\nBack!',
                      style: TextStyle(
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold,
                        color: kTextBlack[800]!,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'EMAIL',
                                labelStyle: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 12.0,
                                    color: Colors.grey.withOpacity(0.5)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kPrimaryColor))),
                            onChanged: (value) {
                              email = value;
                            },
                            validator: (val) {
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)) {
                                return 'Please enter a valid Email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'PASSWORD',
                                labelStyle: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 12.0,
                                    color: Colors.grey.withOpacity(0.5)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kPrimaryColor))),
                            obscureText: true,
                            onChanged: (value) {
                              password = value;
                            },
                            validator: (val) => val!.length < 6
                                ? 'Enter password 6+ characters long'
                                : null,
                          ),
                          SizedBox(height: 50.0),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  if (this.mounted) {
                                    setState(() {
                                      error = "Something went wrong";
                                    });
                                  }
                                }
                              }
                            },
                            child: Container(
                              height: 50.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(25.0),
                                shadowColor: kPrimaryColorAccent,
                                color: kPrimaryColor,
                                elevation: 5.0,
                                child: Center(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () {
                              widget.func!();
                            },
                            child: Container(
                              height: 50.0,
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: kTextBlack[800]!,
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                    ),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(25.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Don\'t have an account? Register',
                                        style: TextStyle(
                                          fontFamily: 'Raleway',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Center(
                            child: Text(
                              error,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

