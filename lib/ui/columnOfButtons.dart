import 'package:comma/util/consts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:comma/model/dictionary.dart';
import 'package:comma/util/myExistingDB.dart';


import 'flipFlop.dart';
import 'mainPage.dart';

class StartContinue extends StatefulWidget {
  @override
  _StartContinueState createState() => _StartContinueState();
}

class _StartContinueState extends State<StartContinue> {
  DbHelperReal dbHelperReal;
  bool isDone;
  List<String> tables;
  List<int> variances;
  String oldTimeParted;
  DateTime oldDatetime;
  @override
  void initState() {
    super.initState();
    tables = [
      'firstplace',
      'secondplace',
      'thirdplace',
      'fourthplace',
      'fifthplace'
    ];
    variances =[1,2,4,8,15];
    isDone = true;
    dbHelperReal = DbHelperReal();

  }
  @override
  Widget build(BuildContext context) {
    return returnSth(isDone);
  }

  returnSth(value) {
    if (value) {
     // print('done!');
      return columnsOfButtons();
    } else {
     // print('not done!');
      return Center(child: CircularProgressIndicator());
    }
  }
  columnsOfButtons() {
    return ListView(
      children: [
            Opacity(
              opacity: 0.9,
              child: Container(
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.only(bottom: 15.0,left: 8.0,right: 8.0,top: 10.0),
                width: 320.0,
                decoration: BoxDecoration( //Color.fromRGBO(0, 230, 118, 1.0),
                    color: Constants.SECONDARY_COLOR,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 8.5,
                        offset: Offset(0.5, 2.0),
                        color: Constants.SECONDARY_COLOR,
                      )
                    ]),
                child: MaterialButton(
                  child: Text(
                    'شروع دوباره!',
                    style: TextStyle(color: Colors.white,fontFamily: 'iransans'),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Icon(
                            Icons.warning,
                            color: Colors.amberAccent,
                          ),
                          content: Text('مطمئنی میخوای از اول شروع کنی؟',style: TextStyle(fontFamily: 'iransans'),),
                          actions: <Widget>[
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton(
                                    shape: RoundedRectangleBorder(),
                                    color: Colors.red,
                                    child: Text("آره!",
                                        style: TextStyle(
                                            fontSize: 16.0, color: Colors.white,fontFamily: 'iransans')),
                                    onPressed: () async{
                                      Navigator.pop(context);
                                    await  dbHelperReal.resetTable();
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainPage()));
                                    }),
                                FlatButton(
                                  shape: RoundedRectangleBorder(),
                                  color: Colors.blue,
                                  child: Text('نه!',
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white,fontFamily: 'iransans')),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ),
                          ],
                        ));
                  },
                ),
              ),
            ),
            Opacity(
              opacity: 0.9,
              child: Container(
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.only(bottom: 15.0,left: 8.0,right: 8.0),
                width: 320.0,
                decoration: BoxDecoration(
                    color: Constants.PRIMARY_COLOR,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 8.5,
                        offset: Offset(0.5, 2.0),
                        color:Constants.PRIMARY_COLOR,
                      )
                    ]),
                child: MaterialButton(
                    child: Text(
                      'مرحله اول',
                      style: TextStyle(color: Colors.white,fontFamily: 'iransans'),
                    ),
                    onPressed: (){
                     onPressForEachPlace(0);

                    }),
              ),
            ),
            Opacity(
              opacity: 0.9,
              child: Container(
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.only(bottom: 15.0,left: 8.0,right: 8.0),
                width: 320.0,
                decoration: BoxDecoration( //Color.fromRGBO(0, 230, 118, 1.0)
                    color: Constants.SECONDARY_COLOR,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 8.5,
                        offset: Offset(0.5, 2.0),
                        color: Constants.SECONDARY_COLOR,
                      )
                    ]),
                child: MaterialButton(
                    child: Text(
                      'مرحله دوم',
                      style: TextStyle(color: Colors.white,fontFamily: 'iransans'),
                    ),
                    onPressed: () {
                     onPressForEachPlace(1);
                    }),
              ),
            ),
            Opacity(
              opacity: 0.9,
              child: Container(
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.only(bottom: 15.0,left: 8.0,right: 8.0),
                width: 320.0,
                decoration: BoxDecoration( //Colors.blue
                    color: Constants.PRIMARY_COLOR,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 8.5,
                        offset: Offset(0.5, 2.0),
                        color: Constants.PRIMARY_COLOR,
                      )
                    ]),
                child: MaterialButton(
                  child: Text(
                    'مرحله سوم',
                    style: TextStyle(color: Colors.white,fontFamily: 'iransans'),
                  ),
                  onPressed: () {
                    onPressForEachPlace(2);
                  },
                ),
              ),
            ),
            Opacity(
              opacity: 0.9,
              child: Container(
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.only(bottom: 15.0,left: 8.0,right: 8.0),
                width: 320.0,
                decoration: BoxDecoration(//Color.fromRGBO(0, 230, 118, 1.0)
                    color: Constants.SECONDARY_COLOR,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 8.5,
                        offset: Offset(0.5, 2.0),
                        color: Constants.SECONDARY_COLOR,
                      )
                    ]),
                child: MaterialButton(
                  child: Text(
                    'مرحله چهارم',
                    style: TextStyle(color: Colors.white,fontFamily: 'iransans'),
                  ),
                  onPressed: () {
                    onPressForEachPlace(3);
                  },
                ),
              ),
            ),
            Opacity(
              opacity: 0.9,
              child: Container(
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.only(left: 8.0,right: 8.0),
                width: 320.0,
                decoration: BoxDecoration( //Colors.blue
                    color:Constants.PRIMARY_COLOR,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 8.5,
                        offset: Offset(0.5, 2.0),
                        color:Constants.PRIMARY_COLOR,
                      )
                    ]),
                child: MaterialButton(
                  child: Text(
                    'مرحله آخر',
                    style: TextStyle(color: Colors.white,fontFamily: 'iransans'),
                  ),
                  onPressed: () {
                    onPressForEachPlace(4);
                  },
                ),
              ),
            )
      ],
    );
  }

  Future<void> onPressForEachPlace(int tableIndex) async{

    List<dynamic> customDictionaryList = List<dynamic>();
    var items =  await dbHelperReal.getWords(tables[tableIndex]);
   // print('item ha be tartib $items');
  //  print('item ha ${items[0]}');
    if(items.length == 0){
     // print('4');
      showColoredToast(Colors.blue, 'خالیه!');
    }
    else{
      //print('3');
      //print('this is my item : ${items}');

      oldTimeParted = Dictionary.fromObject(items[0]).cardTime.toString();
     // print("vay vay $oldTimeParted");
      oldDatetime = DateTime(int.parse(oldTimeParted.substring(0,4)),
          int.parse(oldTimeParted.substring(4,6)),
          int.parse(oldTimeParted.substring(6,8)),
          int.parse(oldTimeParted.substring(8,10)),
          int.parse(oldTimeParted.substring(10)));//days: variances[tableIndex]
      if(!(DateTime.now().difference(oldDatetime) >= Duration(days: variances[tableIndex]))){
       // print('1');
        showColoredToast(Colors.red, 'زمان مرور کارتی فرا نرسیده!');
      }
      else{

        if(await checkGoingBackBig(tableIndex)){
          showColoredToast(Colors.amberAccent,'اول مراحل قبلی رو بررسی کن.');
        }
        else{
          for(int i = 0 ; i<items.length ; i++){
            oldTimeParted = Dictionary.fromObject(items[i]).cardTime.toString();
            //print('olde : $oldDatetime');
            oldDatetime = DateTime(int.parse(oldTimeParted.substring(0,4)),
                int.parse(oldTimeParted.substring(4,6)),
                int.parse(oldTimeParted.substring(6,8)),
                int.parse(oldTimeParted.substring(8,10)),
                int.parse(oldTimeParted.substring(10))); //days: variances[tableIndex]
            if(DateTime.now().difference(oldDatetime) >= Duration(days: variances[tableIndex])){
              customDictionaryList.add(items[i]);
            }
            else{
              break;
            }
          }
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ShowFlips(obsRev: 1,tableIndex: tableIndex,
              customDictionaryList: customDictionaryList,),
          ));
        }
      }

    }
  }
  Future<bool> checkGoingBackBig(int tableIndex) async{

        for (int i = 0; i < tableIndex; i++) {
          var items = await dbHelperReal.getWords(tables[i]);
          if(items.length != 0){
          var  oldTimeParted = Dictionary
                .fromObject(items[0])
                .cardTime
                .toString();
          var oldDatetime = DateTime(int.parse(oldTimeParted.substring(0,4)),
                int.parse(oldTimeParted.substring(4,6)),
                int.parse(oldTimeParted.substring(6,8)),
                int.parse(oldTimeParted.substring(8,10)),
                int.parse(oldTimeParted.substring(10)));//days: variances[i]
            if (DateTime.now().difference(oldDatetime) >=
                Duration(days: variances[i])) {
              return true;
            }
          }
        }
        return false;
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
