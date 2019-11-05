import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_model/main.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: '',
        labelText: '  E-Mail',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0),
          borderRadius: BorderRadius.circular(30.0),
        ),
        labelText: '  Potwierdź hasło',
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Passwords do not match';
        }
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0),
          borderRadius: BorderRadius.circular(30.0),
        ),
        labelText: '  Hasło',
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildAcceptSwitch(BuildContext context) {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Zaakceptuj warunki'),
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() ||
        (!_formData['acceptTerms'] && _authMode == AuthMode.Signup)) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);
    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An error occurred'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okay'),
              )
            ],
          );
        },
      );
    }
  }

  void _passwordForgotten(BuildContext context) {}

  void _termsAndConditions(BuildContext context) {
    List<String> values = [
      "1. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      "2. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      "3. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    ];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              "Warunki uzytkowania",
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            content: new Container(
              
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.95,
              child: ListView.builder(
                  itemCount: values.length,
                  itemBuilder: (BuildContext buildContext, int index) =>
                      new Text(values[index]),
                  shrinkWrap: true),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? deviceWidth * 0.95 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${_authMode == AuthMode.Login ? 'Zaloguj' : 'Załóź konto'}'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: targetWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _authMode == AuthMode.Login
                            ? Container(
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        size: 120.0,
                                      ),
                                      Text(
                                        'reAppka',
                                        style: Theme.of(context)
                                            .textTheme
                                            .display3,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                        SizedBox(
                          height: 10.0,
                        ),
                        _buildEmailTextField(),
                        SizedBox(
                          height: 10.0,
                        ),
                        _buildPasswordTextField(),
                        SizedBox(
                          height: 10.0,
                        ),
                        _authMode == AuthMode.Signup
                            ? _buildPasswordConfirmTextField()
                            : Container(height: 10.0),
                        _authMode == AuthMode.Signup
                            ? _buildAcceptSwitch(context)
                            : Container(),
                        SizedBox(
                          height: 10.0,
                        ),
                        ScopedModelDescendant<MainModel>(
                          builder: (
                            BuildContext context,
                            Widget child,
                            MainModel model,
                          ) {
                            return RaisedButton(
                              elevation: 0.0,
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    _authMode == AuthMode.Login ? 140.0 : 125.0,
                                vertical: 20.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text(_authMode == AuthMode.Login
                                  ? 'Zaloguj'
                                  : 'Zarejestruj'),
                              onPressed: () => _submitForm(model.authenticate),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: FlatButton(
                                child: Text(
                                    '${_authMode == AuthMode.Login ? 'Załóz konto' : 'Zaloguj'}'),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  setState(() {
                                    _authMode = _authMode == AuthMode.Login
                                        ? AuthMode.Signup
                                        : AuthMode.Login;
                                  });
                                },
                              ),
                            ),
                            _authMode == AuthMode.Login
                                ? Container(
                                    child: FlatButton(
                                        child: Text('Zapomniałem hasła'),
                                        onPressed: () {
                                          _passwordForgotten(context);
                                        }),
                                  )
                                : Container(
                                    child: FlatButton(
                                        child: Text('Warunki uzytkowania'),
                                        onPressed: () {
                                          _termsAndConditions(context);
                                        }),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
