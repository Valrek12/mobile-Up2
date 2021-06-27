import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:up2_application_mobile/models/task.dart';
import 'package:up2_application_mobile/models/time_object.dart';
import 'package:up2_application_mobile/service/up2_repository.dart';
import 'package:up2_application_mobile/utils/color_page.dart';

class Tracking extends StatefulWidget {
  final Future Function() notifyParent;
  final Task task;
  final String login;
  final String password;
  final String selectDay;

  const Tracking(
      {Key key,
      this.task,
      this.login,
      this.password,
      @required this.notifyParent,
      this.selectDay})
      : super(key: key);
  TrackingState createState() => TrackingState();
}

class TrackingState extends State<Tracking> {
  final Color appColor = HexColor.fromHex('#242424');
  int _currentHours;
  int _curretnMinut;
  Up2Repository basicAuthUp2 = new Up2Repository();
  TimeObject timeObject;
  final comment = TextEditingController();
  ProgressDialog pr;
  bool disabled;
  String errorMessage;
  FocusNode myFocusNode;

  @override
  void initState() {
    disabled = true;
    _currentHours = 0;
    _curretnMinut = 0;
    myFocusNode = FocusNode();
    super.initState();
  }

  Widget hourseWidget() {
    return NumberPicker(
      axis: Axis.vertical,
      selectedTextStyle: TextStyle(color: Colors.orange, fontSize: 30.0),
      value: _currentHours,
      minValue: 0,
      maxValue: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColor),
      ),
      onChanged: (value) => setState(() => _currentHours = value),
    );
  }

  Widget minuteWidget() {
    return NumberPicker(
      axis: Axis.vertical,
      selectedTextStyle: TextStyle(color: Colors.orange, fontSize: 30.0),
      value: _curretnMinut,
      minValue: 0,
      maxValue: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColor),
      ),
      onChanged: (value) => setState(() => _curretnMinut = value),
    );
  }

  Future<TimeObject> updateTime(String businessObjectId, String sign,
      String comment, String date, bool force, int hours, int minutes) async {
    await basicAuthUp2
        .signIn(widget.login, widget.password)
        .then((value) async => {
              errorMessage = value.message,
              await basicAuthUp2
                  .updateTime(value.data.token, businessObjectId, sign, comment,
                      date, force, hours, minutes, value.data.id)
                  .then((value) => {timeObject = value})
            });
    return timeObject;
  }

  void add() {
    pr.show();
    updateTime(widget.task.id, "+", comment.text, widget.selectDay, false,
            _currentHours, _curretnMinut)
        .then((value) {
      pr.hide().whenComplete(() => {widget.notifyParent()});
    });
  }

  void subsctract() {
    pr.show();
    updateTime(widget.task.id, "-", comment.text, widget.selectDay, false,
            _currentHours, _curretnMinut)
        .then((value) {
      pr.hide().whenComplete(() => {widget.notifyParent()});
    });
  }

  bool isDesabled() {
    if (_currentHours != 0 || _curretnMinut != 0) {
      return false;
    }
    return true;
  }

  Widget outButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      label: Text(
        'Назад',
        style: TextStyle(color: Colors.orange),
      ),
      icon: Icon(
        Icons.transit_enterexit_outlined,
        color: Colors.white,
      ),
      onPressed: () => Navigator.pop(context),
      textColor: Colors.white,
      splashColor: Colors.orange,
      color: appColor,
    );
  }

  Widget addButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      label: Text(
        'Добавить время',
        style: TextStyle(color: Colors.orange),
      ),
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      textColor: Colors.white,
      splashColor: Colors.orange,
      color: appColor,
      onPressed: isDesabled() ? null : () => add(),
    );
  }

  Widget subtractButton() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        label: Text(
          'Сторнировать  ',
          style: TextStyle(color: Colors.orange),
        ),
        icon: Icon(
          Icons.remove,
          color: Colors.white,
        ),
        textColor: Colors.white,
        splashColor: Colors.orange,
        color: appColor,
        onPressed: isDesabled() ? null : () => subsctract());
  }

  Widget listView() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      shrinkWrap: true,
      children: <Widget>[
        Row(children: <Widget>[
          Padding(
            child: Text('Часы', style: TextStyle(fontWeight: FontWeight.bold)),
            padding: const EdgeInsets.fromLTRB(130.0, 25.0, 40.0, 0.0),
          ),
          Padding(
            child:
                Text('Минуты', style: TextStyle(fontWeight: FontWeight.bold)),
            padding: const EdgeInsets.fromLTRB(20.0, 25.0, 40.0, 0.0),
          ),
        ]),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[hourseWidget(), minuteWidget()],
        ),
        Container(
          width: 20,
          height: 170,
          child: TextField(
            textInputAction: TextInputAction.done,
            onSubmitted: (term) {
              myFocusNode.unfocus();
            },
            autofocus: true,
            focusNode: myFocusNode,
            maxLines: 99,
            controller: comment,
            decoration: InputDecoration(
              hintText: "Комментарий",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[addButton(), subtractButton()],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Please Waiting...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return ListView(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      shrinkWrap: true,
      children: <Widget>[
        Center(
            child: Text(
          widget.task.title,
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(fontSize: 17.0),
        )),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[hourseWidget(), minuteWidget()],
        ),
        Container(
          width: 20,
          height: 170,
          child: TextField(
            textInputAction: TextInputAction.done,
            onSubmitted: (term) {
              myFocusNode.unfocus();
            },
            focusNode: myFocusNode,
            maxLines: 99,
            controller: comment,
            decoration: InputDecoration(
              hintText: "Комментарий",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[addButton(), subtractButton()],
        ),
        Center(child: outButton())
      ],
    );
  }
}
