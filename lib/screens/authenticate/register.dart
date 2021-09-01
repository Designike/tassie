import 'package:flutter/material.dart';
import 'package:tassie/utilities/auth.dart';
import 'package:tassie/utilities/database.dart';

class Register extends StatefulWidget {
  final Function? func;
  Register({this.func});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthUtil _auth = AuthUtil();
  String password = "";
  String email = "";
  String error = "";
  String name = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Temp"),
        backgroundColor: Colors.black87,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign in'),
            onPressed: () => widget.func!(),
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) =>
                        val!.length == 0 ? 'Enter your name' : null,
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) {
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)) {
                        return 'Please a valid Email';
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
                    child: Text('Register'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result = await _auth
                            .registerWithEmailAndPasword(email, password, name);
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
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
