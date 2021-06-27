import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:up2_application_mobile/pages/home_page.dart';
import 'package:up2_application_mobile/pages/root_pages/login_sign_up.dart';
import 'package:up2_application_mobile/service/up2_provider.dart';

class RootPage extends StatefulWidget {
  RootPage({this.params, this.auth});

  final Up2Provider auth;
  final Map params;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoggedIn = false;
  String login;
  String password;
  String token;
  String userInfo;
  String userId;

  @override
  void initState() {
    super.initState();
    autoLogIn().whenComplete(() => {
          widget.auth.signIn(login, password).then((value) => {
                setState(() {
                  if (value?.data?.id != null) {
                    token = value.data.token;
                    widget.auth
                        .getCurrentUser(token)
                        .then((value) => {userInfo = value?.userInfo?.title});
                  }
                  authStatus = value?.data?.token == null
                      ? AuthStatus.NOT_LOGGED_IN
                      : AuthStatus.LOGGED_IN;
                })
              })
        });
  }

  Future<Null> autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String loginId = prefs.getString('username');
    final String passwordId = prefs.getString('password');
    final String userInfoId = prefs.getString('userInfo');
    final String userIdInfo = prefs.getString('userId');

    if (passwordId != null && loginId != null) {
      setState(() {
        isLoggedIn = true;
        login = loginId;
        password = passwordId;
        userInfo = userInfoId;
        userId = userIdInfo;
      });
      return;
    }
  }

  void _onLoggedIn() {
    autoLogIn().whenComplete(() => {
          widget.auth.signIn(login, password).then((value) => {
                token = value.data.id,
                setState(() {
                  authStatus = AuthStatus.LOGGED_IN;
                })
              }),
        });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      login = "";
    });
  }

  Widget _waitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
          params: widget.params,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (token.length > 0 && token != null) {
          return new HomePage(
            userId: login,
            passwordId: password,
            userInfo: userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
        } else
          return _waitingScreen();
        break;
      default:
        return _waitingScreen();
    }
  }
}
