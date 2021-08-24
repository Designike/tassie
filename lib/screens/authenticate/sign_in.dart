import 'package:flutter/material.dart';
import 'package:tassie/utilities/auth.dart';

class SignIn extends StatefulWidget {
  final Function? func;
  SignIn({this.func});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthUtil _auth = AuthUtil();
  String password = "";
  String email = "";
  String error = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In Temp"),
        backgroundColor: Colors.black87,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () => widget.func!(),
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  validator: (val) {
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)) {
                      return 'Please enter a valid Email';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  validator: (val) => val!.length < 6
                      ? 'Enter password 6+ characters long'
                      : null,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  child: Text('Sign In'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          error = "Something went wrong";
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[850],
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
