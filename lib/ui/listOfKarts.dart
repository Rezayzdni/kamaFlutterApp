
import 'dart:async';


import 'package:comma/util/consts.dart';
//import 'package:comma/util/zarinPay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:comma/model/dictionary.dart';
import 'package:comma/ui/mainPage.dart';
import 'package:comma/util/cafePay.dart';
import 'package:comma/util/myExistingDB.dart';
import 'package:shared_preferences/shared_preferences.dart';





class ListOfKarts extends StatefulWidget {


  @override
  _ListOfKartsState createState() => _ListOfKartsState();
}

class _ListOfKartsState extends State<ListOfKarts> {
  List<Dictionary> instancesOfDictionaryClass;
  DbHelperReal dbHelperReal;
  bool loading;
  int keep30;
  bool purchaseComplete;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keep30 = 0;
    purchaseComplete = false;
    loading = true;
    instancesOfDictionaryClass = List<Dictionary>();
    dbHelperReal = DbHelperReal();
    getDictionaryItems();
  }

  Future<void> _loadSharedPrefs() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getInt('keep30') != null){
      setState(() {
        this.keep30 = preferences.getInt('keep30');
      });
    }
    if(preferences.getBool('purchaseFlow') != null){
      setState(() {
        this.purchaseComplete = preferences.getBool('purchaseFlow');
      });
    }
  }
  Future<void> _saveSharedPrefs(int keepIt) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('keep30',keepIt);
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
       Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'کاما لیست',
            style: TextStyle(fontFamily: 'iransans'),
          ),
          centerTitle: true,//Colors.blue[500]
          backgroundColor: Constants.PRIMARY_COLOR,
          automaticallyImplyLeading: false,
          leading: FlatButton(
            shape: CircleBorder(),
            child: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
            ),
            onPressed: () async {

                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute( //KartVariety()
                      builder: (context) => MainPage(),
                    ));

            },
          ),
        ),
        body: emptyOrSth(),
      ),
    );
    //}
  }

  emptyOrSth() {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    } else {
        return ListView.builder(
          itemCount: instancesOfDictionaryClass.length,
          itemBuilder: (BuildContext context, int position) {
            return Card(
              child: Container(
                //  margin: EdgeInsets.only(left: 5.0,right: 5.0),
                decoration: BoxDecoration(//Colors.blue[500]
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Constants.PRIMARY_COLOR,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,//Color.fromRGBO(0, 230, 118, 1.0)
                    backgroundColor: Constants.SECONDARY_COLOR,
                    child: Text(
                      '${position + 1}',
                      style: TextStyle(
                          fontFamily: 'iransans', color: Colors.white),
                    ),
                  ),
                  title:instancesOfDictionaryClass[position].en.contains('(') ? Text(
                  '${instancesOfDictionaryClass[position].en}'.replaceAll('(','')+')'.trim(),maxLines: 2,
                  style:
                  TextStyle(fontFamily: 'iransans', color: Colors.white),
                )  : Text('${instancesOfDictionaryClass[position].en}'.trim(),style:
                    TextStyle(fontFamily: 'iransans', color: Colors.white),maxLines: 2,),
                  subtitle: Text(
                    '${instancesOfDictionaryClass[position].fa}'.trim(),
                    style:
                        TextStyle(fontFamily: 'iransans', color: Colors.white),maxLines: 2,
                  ),
                  onLongPress: () async{
                   await _loadSharedPrefs();//keep30 < 5 || purchaseComplete
                        if(keep30 < 5 || purchaseComplete){
                          if(!purchaseComplete){
                            keep30++;
                            await _saveSharedPrefs(keep30);
                          }
                          await dbHelperReal.deleteWord(
                              instancesOfDictionaryClass[position].id,
                              'tmpplace');
                          instancesOfDictionaryClass[position].cardTime = int.parse(getStandardTime());
                          //print('time after : ${instancesOfDictionaryClass[position].cardTime}');
                          //print('the fucking id is : ${instancesOfDictionaryClass[position].id}');
                          await dbHelperReal.insertWord(
                              instancesOfDictionaryClass[position],
                              'firstplace');
                          setState(() {
                            instancesOfDictionaryClass
                                .removeAt(position);
                          });
                        }
                        else{
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Icon(
                                  Icons.info,
                                  color: Colors.blue,
                                ),
                                content: Text(
                                  'شما 5 کارت رایگان خودتون رو انتخاب کردیدلطفا برای خریداری کامل برنامه اقدام کنید.',
                                  style: TextStyle(fontFamily: 'iransans'),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text("فعلا نه!",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.blue,
                                              fontFamily: 'iransans')),
                                      shape: RoundedRectangleBorder(),
                                      onPressed: () {
                                        //tmpDictionaryList = await dbHelperReal.getWords('tmpplace');
                                        Navigator.pop(context);
                                      }),
                                  FlatButton(
                                      child: Text("بررسی وضعیت پرداخت",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.blue,
                                              fontFamily: 'iransans')),
                                      shape: RoundedRectangleBorder(),
                                      onPressed: () async{
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => PaymentPage()
                                        ));
                                      }),
                                ],
                              ));
                        }
                  },
                  contentPadding: EdgeInsets.all(2.0),
                ),
              ),
            );
          },
        );
    }
  }
  String getStandardTime(){
    String tmpString = DateFormat.Hm().format(DateTime.now()).replaceAll(':', '-');
    String currentTime = DateFormat('yyyy-MM-dd').format(DateTime.now())+'-' + tmpString;
    return currentTime.replaceAll('-', '');
  }


  void getDictionaryItems() async{
    var theItems = await dbHelperReal.getWords('tmpplace');
    theItems.forEach((element) {
      instancesOfDictionaryClass.add(Dictionary.fromObject(element));
    });
    setState(() {
      loading = false;
    });
  }
}
