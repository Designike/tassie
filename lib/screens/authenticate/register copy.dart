import 'package:flutter/material.dart';
import 'package:tassie/utilities/auth.dart';
import 'package:tassie/utilities/database.dart';

class RegisterC extends StatefulWidget {
  final Function? func;
  RegisterC({this.func});
  @override
  _RegisterCState createState() => _RegisterCState();
}

class _RegisterCState extends State<RegisterC> {
  final AuthUtil _auth = AuthUtil();
  String password = "";
  String email = "";
  String error = "";
  String name = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: ListView(
            children: [
              SizedBox(height: 75.0),
              Container(
                height: 125.0,
                width: 200.0,
                child: Stack(
                  children: [
                    Text(
                      'Hey',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 60.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Positioned(
                        top: 50.0,
                        child: Text(
                          'There!',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 60.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'NAME',
                    labelStyle: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 12.0,
                        color: Colors.grey.withOpacity(0.5)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber))),
                onChanged: (value) {
                  name = value;
                },
                validator: (val) => val!.length < 2 ? 'Enter valid name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'EMAIL',
                    labelStyle: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 12.0,
                        color: Colors.grey.withOpacity(0.5)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber))),
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
                        borderSide: BorderSide(color: Colors.amber))),
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
                    dynamic result = await _auth.registerWithEmailAndPasword(
                        email, password, name);
                    if (result == null) {
                      setState(() {
                        error = "Something went wrong";
                      });
                    }
                  }
                },
                child: Container(
                  height: 50.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(25.0),
                    shadowColor: Colors.amberAccent,
                    color: Colors.amber,
                    elevation: 5.0,
                    child: Center(
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.white,
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
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Already have an account? Sign In',
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
    ));
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Register Temp"),
    //     backgroundColor: Colors.black87,
    //     elevation: 0.0,
    //     actions: <Widget>[
    //       TextButton.icon(
    //         icon: Icon(Icons.person),
    //         label: Text('Sign in'),
    //         onPressed: () => widget.func!(),
    //       ),
    //     ],
    //   ),
    //   body: Center(
    //     child: Container(
    //       child: Form(
    //         key: _formKey,
    //         child: SingleChildScrollView(
    //           child: Column(
    //             children: <Widget>[
    //               SizedBox(height: 20.0),
    //               TextFormField(
    //                 validator: (val) =>
    //                     val!.length == 0 ? 'Enter your name' : null,
    //                 onChanged: (val) {
    //                   setState(() {
    //                     name = val;
    //                   });
    //                 },
    //               ),
    //               SizedBox(height: 20.0),
    //               TextFormField(
    //                 validator: (val) {
    //                   if (!RegExp(
    //                           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //                       .hasMatch(val!)) {
    //                     return 'Please a valid Email';
    //                   }
    //                   return null;
    //                 },
    //                 onChanged: (val) {
    //                   setState(() {
    //                     email = val;
    //                   });
    //                 },
    //               ),
    //               SizedBox(height: 20.0),
    //               TextFormField(
    //                 obscureText: true,
    //                 validator: (val) => val!.length < 6
    //                     ? 'Enter password 6+ characters long'
    //                     : null,
    //                 onChanged: (val) {
    //                   setState(() {
    //                     password = val;
    //                   });
    //                 },
    //               ),
    //               SizedBox(height: 20.0),
    //               ElevatedButton(
    //                 child: Text('Register'),
    //                 onPressed: () async {
    //                   if (_formKey.currentState!.validate()) {
    //                     dynamic result = await _auth
    //                         .registerWithEmailAndPasword(email, password, name);
    //                     if (result == null) {
    //                       setState(() {
    //                         error = "Something went wrong";
    //                       });
    //                     }
    //                   }
    //                 },
    //                 style: ElevatedButton.styleFrom(
    //                   primary: Colors.grey[850],
    //                 ),
    //               ),
    //               SizedBox(height: 12.0),
    //               Text(
    //                 error,
    //                 style: TextStyle(color: Colors.red, fontSize: 14.0),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
