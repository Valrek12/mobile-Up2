import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:up2_application_mobile/service/up2_provider.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.params, this.auth, this.onSignedIn});

  final Map params;
  final Up2Provider auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP, FORGOTPASSWORD }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _login;
  String _password;
  String _userInfo;
  String _errorMessage;
  String _userId;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<Null> loginUser(
      String login, String password, String userInfo, String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', login);
    prefs.setString('password', password);
    prefs.setString('userInfo', userInfo);
    prefs.setString('userId', userId);
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          await widget.auth.signIn(_login, _password).then((value) => {
                if (value?.data?.token != null)
                  {
                    userId = value.data.token,
                    _userId = value.data.id,
                    _errorMessage = value.message
                  }
                else
                  {_errorMessage = value.message}
              });
        }
        setState(() {
          _isLoading = false;
        });
        widget.auth
            .getCurrentUser(userId)
            .then((value) => {
                  loginUser(_login, _password, value.userInfo.title, _userId),
                  _userInfo = value?.userInfo?.title
                })
            .then((value) => {
                  if (userId.length > 0 &&
                      userId != null &&
                      _formMode == FormMode.LOGIN)
                    {widget.onSignedIn()}
                });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _isIos ? _errorMessage = e.details : _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showLoginInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Container(
          padding: const EdgeInsets.fromLTRB(50.0, 50.0, 0.0, 0.0),
          child: Text(
            _errorMessage,
            style: TextStyle(
              color: Colors.red,
              height: 2.0,
              fontWeight: FontWeight.w300,
            ),
          ));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
        tag: 'hero',
        child: Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: Center(
            child: Container(
                width: 300, height: 150, child: Image.asset('images/logo.jpg')),
          ),
        ));
  }

  Widget _showLoginInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 40.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Login',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _login = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    if (_formMode != FormMode.FORGOTPASSWORD) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 40.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Password',
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value.trim(),
        ),
      );
    } else {
      return new Text(
          'An email will be sent allowing you to reset your password',
          style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300));
    }
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 4.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.black,
            child: _textPrimaryButton(),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  Widget _textPrimaryButton() {
    switch (_formMode) {
      case FormMode.LOGIN:
        return new Text('Login',
            style: new TextStyle(fontSize: 20.0, color: Colors.orange));
        break;
      case FormMode.SIGNUP:
        return new Text('Create account',
            style: new TextStyle(fontSize: 20.0, color: Colors.white));
        break;
      case FormMode.FORGOTPASSWORD:
        return new Text('Reset password',
            style: new TextStyle(fontSize: 20.0, color: Colors.white));
        break;
    }
    return new Spacer();
  }
}
