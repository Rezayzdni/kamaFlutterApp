import 'package:comma/util/consts.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comma/ui/flipFlop.dart';
import 'package:comma/ui/mainPage.dart';
import 'package:comma/util/myExistingDB.dart';

import 'listOfKarts.dart';

//import 'listOfKarts.dart';

class Timing extends StatelessWidget {
  Timing(this.listCounter,this.tmpPlaceCounter);
  final List<int> listCounter;
  final int tmpPlaceCounter;
  //final List<int> wordCategoryNumbers;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Opacity(
          opacity: 0.9,
          child: Container(
            padding: EdgeInsets.all(4.0),
            margin: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 5.0),
            decoration: BoxDecoration(//Color.fromRGBO(0, 230, 118, 1.0)
                color: Constants.SECONDARY_COLOR,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 8.5,
                      offset: Offset(0.5, 2.0),
                      color: Constants.SECONDARY_COLOR)
                ]),
            child: MaterialButton(

              child: Text(
                'مجموعه کاما (${tmpPlaceCounter} کارت)',
                style: TextStyle(color: Colors.white, fontFamily: 'iransans'),
              ),


              onPressed: () async{

               // DbHelperReal dbHelperReal = DbHelperReal();
                /*
                var tmpDictionaryList =
                await dbHelperReal.getWords('tmpplace');

                 */
                if(await _loadSharedPrefs()){
                  _saveSharedPrefs(false);
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Icon(
                          Icons.info,
                          color: Colors.blue,
                        ),
                        content: Text(
                          'با نگه داشتن روی هر کارت میتونی اون رو به مرحله اول بیاری \n و اینکه بعضی کارت ها قابل اسکرول هستن ;)',
                          style: TextStyle(fontFamily: 'iransans'),
                        ),
                        actions: <Widget>[
                          FlatButton(
                              child: Text("باشه",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.blue,
                                      fontFamily: 'iransans')),
                              shape: RoundedRectangleBorder(),
                              onPressed: () async {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        ListOfKarts()));
                              }),
                        ],
                      ));
                }
                else{
                  if(tmpPlaceCounter == 0){
                    showColoredToast(Colors.blue, 'خالیه');
                  }
                  else{
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ListOfKarts()),);
                  }

                }

              },
            ),
          ),
        ),
        Opacity(
          opacity: 0.9,
          child: Container(
            padding: EdgeInsets.all(4.0),
            margin: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 8.0),
            decoration: BoxDecoration( //Colors.blue
                color: Constants.PRIMARY_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 8.5,
                      offset: Offset(0.5, 2.0),
                      color: Constants.PRIMARY_COLOR)
                ]),
            child: MaterialButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'خانه اول',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'iransans'),
                  ),
                  Text(
                    'تعداد کارت‌ها: ${this.listCounter[0]}',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'iransans'),
                  )
                ],
              ),
              onPressed: () async {

                DbHelperReal dbHelperReal = DbHelperReal();
                var customDictionaryList = await dbHelperReal.getWords('firstplace');
                if(customDictionaryList.length == 0){
                  showColoredToast(Colors.blue, 'اینجا خالیه!');
                }
                else{
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShowFlips(
                                customDictionaryList: customDictionaryList,
                                obsRev: 0,tableIndex: 0,)));
                }
              },
            ),
          ),
        ),
        Opacity(
          opacity: 0.9,
          child: Container(
              padding: EdgeInsets.all(4.0),
              margin: EdgeInsets.fromLTRB(8.0, 7.0, 8.0, 7.0),
              decoration: BoxDecoration( //Color.fromRGBO(0, 230, 118, 1.0)
                  color: Constants.SECONDARY_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 6.5,
                        offset: Offset(0.5, 2.0),
                        color:Constants.SECONDARY_COLOR)
                  ]),
              child: MaterialButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('خانه دوم',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'iransans')),
                    Text('تعداد کارت‌ها: ${this.listCounter[1]}',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'iransans'))
                  ],
                ),
                onPressed: () async {
                  DbHelperReal dbHelperReal = DbHelperReal();
                  var customDictionaryList = await dbHelperReal.getWords('secondplace');
                  if(customDictionaryList.length == 0){
                    showColoredToast(Colors.blue, 'اینجا خالیه!');
                  }
                  else{
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShowFlips(
                                  customDictionaryList: customDictionaryList,
                                  obsRev: 0,tableIndex: 1,)));
                  }
                },
              )),
        ),
        Opacity(
          opacity: 0.9,
          child: Container(
              padding: EdgeInsets.all(4.0),
              margin: EdgeInsets.fromLTRB(8.0, 7.0, 8.0, 7.0),
              decoration: BoxDecoration(//Colors.blue
                  color: Constants.PRIMARY_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 6.5,
                        offset: Offset(0.5, 2.0),
                        color:Constants.PRIMARY_COLOR)
                  ]),
              child: MaterialButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('خانه سوم',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'iransans')),
                    Text('تعداد کارت‌ها: ${this.listCounter[2]}',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'iransans'))
                  ],
                ),
                onPressed: () async {
                  DbHelperReal dbHelperReal = DbHelperReal();
                  var customDictionaryList = await dbHelperReal.getWords('thirdplace');
                  if(customDictionaryList.length == 0){
                    showColoredToast(Colors.blue, 'اینجا خالیه!');
                  }
                  else{
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShowFlips(
                                  customDictionaryList: customDictionaryList,
                                  obsRev: 0,tableIndex: 2,)));
                  }
                },
              )),
        ),
        Opacity(
          opacity: 0.9,
          child: Container(
              padding: EdgeInsets.all(4.0),
              margin: EdgeInsets.fromLTRB(8.0, 7.0, 8.0, 7.0),
              decoration: BoxDecoration( //Color.fromRGBO(0, 230, 118, 1.0)
                  color: Constants.SECONDARY_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 6.5,
                        offset: Offset(0.5, 2.0),
                        color: Constants.SECONDARY_COLOR)
                  ]),
              child: MaterialButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('خانه چهارم',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'iransans')),
                    Text('تعداد کارت‌ها: ${this.listCounter[3]}',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'iransans'))
                  ],
                ),
                onPressed: () async {
                  DbHelperReal dbHelperReal = DbHelperReal();
                  var customDictionaryList = await dbHelperReal.getWords('fourthplace');
                  if(customDictionaryList.length == 0){
                    showColoredToast(Colors.blue, 'اینجا خالیه!');
                  }
                  else{
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShowFlips(
                                  customDictionaryList: customDictionaryList,
                                  obsRev: 0,tableIndex: 3,)));
                  }
                },
              )),
        ),
        Opacity(
          opacity: 0.9,
          child: Container(
              padding: EdgeInsets.all(4.0),
              margin: EdgeInsets.fromLTRB(8.0, 7.0, 8.0, 7.0),
              decoration: BoxDecoration( // Colors.blue
                  color: Constants.PRIMARY_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 6.5,
                        offset: Offset(0.5, 2.0),
                        color: Constants.PRIMARY_COLOR)
                  ]),
              child: MaterialButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'خانه پنجم',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'iransans'),
                    ),
                    Text(
                      'تعداد کارت‌ها: ${this.listCounter[4]}',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'iransans'),
                    )
                  ],
                ),
                onPressed: () async {
                  DbHelperReal dbHelperReal = DbHelperReal();
                  var customDictionaryList = await dbHelperReal.getWords('fifthplace');
                  if(customDictionaryList.length == 0){
                    showColoredToast(Colors.blue, 'اینجا خالیه!');
                  }
                  else{
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShowFlips(
                                  customDictionaryList: customDictionaryList,
                                  obsRev: 0,tableIndex: 4,)));
                  }
                },
              )),
        ),
      ],
    );
  }
  Future<bool> _loadSharedPrefs() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getBool('dialog0') != null){

        return preferences.getBool('dialog0');

    }
    return true;

  }
  void _saveSharedPrefs(bool dialog) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('dialog0', dialog);
  }
  void showColoredToast(Color color, String text) {
    Fluttertoast.showToast(
      msg: text,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: color,
      textColor: Colors.white,
    );
  }
}
