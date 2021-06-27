import 'package:flutter/material.dart';
import 'package:up2_application_mobile/main.dart';
import 'package:up2_application_mobile/pages/search_pages/search_task_page.dart';
import 'package:up2_application_mobile/pages/up2_page.dart';
import 'package:up2_application_mobile/service/up2_provider.dart';
import 'package:up2_application_mobile/bloc/connection_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:up2_application_mobile/utils/color_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {Key key,
      this.auth,
      this.onSignedOut,
      this.userId,
      this.passwordId,
      this.userInfo})
      : super(key: key);

  final Up2Provider auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String passwordId;
  final String userInfo;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color appColor = HexColor.fromHex('#242424');
  ConnectionCubit _cubit;
  int _selectedIndex = 0;
  String userId;
  TextEditingController controller = TextEditingController();

  List<Widget> _widgetOptions() {
    return <Widget>[
      new Up2Page(
        login: widget.userId,
        password: widget.passwordId,
      ),
      new Scaffold(
        body: new SearchTaskPage(
          login: widget.userId,
          password: widget.passwordId,
          userInfo: widget.userInfo,
        ),
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);
    prefs.setString('password', null);
    prefs.setString('userInfo', null);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    userId = widget.userId;
    super.initState();
    _cubit = ConnectionCubit();
  }

  @override
  void dispose() {
    _cubit?.close();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.dispose();
  }

  Widget getAppBar() {
    if (_selectedIndex == 0) {
      return Text('Мое время', style: TextStyle(color: Colors.orange));
    }
    if (_selectedIndex == 1) {
      return Text('Поиск задач', style: TextStyle(color: Colors.orange));
    }

    return Text('Настройки', style: TextStyle(color: Colors.orange));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            backgroundColor: appColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: appColor),
            elevation: 0.0,
            centerTitle: true,
            title: getAppBar(),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.exit_to_app_outlined,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    logout().whenComplete(() => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Up2App()))
                        });
                  })
            ],
          )),
      body: Center(
        child: BlocBuilder<ConnectionCubit, ConnectionEthernateState>(
            bloc: _cubit,
            builder: (context, state) => state.connected
                ? _widgetOptions().elementAt(_selectedIndex)
                : Text(
                    "Нет соединения с интернет!",
                    style: TextStyle(color: Colors.grey),
                  )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Поиск задач',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
        backgroundColor: appColor,
        unselectedItemColor: Colors.white70,
      ),
    );
  }
}
