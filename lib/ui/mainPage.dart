import 'dart:typed_data';
import 'package:comma/util/cafePay.dart';
import 'package:comma/util/consts.dart';
//import 'package:comma/util/zarinPay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comma/util/myExistingDB.dart';
import 'columnOfButtons.dart';
import 'info.dart';
import 'numbersOf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:comma/util/myNotification.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  SharedPreferences preferences;
  List<int> numberOfWordsInEachPlace;
  int tmpPlaceCounter;
  MyNotification myNotification;
  DbHelperReal dbHelperReal;
  List<Widget> itemsOfBottomNav;
  int itemIndex;
  bool isGetWholeData;
  int _sharedPrefData;
  String _sharedPrefDay;
  bool _sharedDataBase;
  bool isDoneUrl;
  final titles = ['توضیحات','کاما(آموزش کاربردی گرامر)', 'مراحل'];
  List<String> keepTimes;



  @override
  void initState() {
    super.initState();


    isGetWholeData = false;
    _sharedDataBase = true;
    _sharedPrefData = 6;
    _sharedPrefDay = '0-0-0-0-0';
    myNotification = MyNotification();
    numberOfWordsInEachPlace = [0,0,0,0,0];
    keepTimes = ['','','','',''];
    itemIndex = 1;
    getWholeData();
  }


  getWholeData() async {


    Directory dir = await getApplicationDocumentsDirectory();
    String  path = dir.path + "dictionary_ss77.db";
    await  _loadSharedPrefs();
    //_sharedDataBase = true;

    if(_sharedDataBase){
      await _saveSharedPrefsDataBase(false);
      ByteData data = await rootBundle.load(join("assets/databases", "fekr.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes,flush: true);
      //await File(path_0).writeAsBytes(bytes,flush: true);
    }

      var sharedPrefDayParted = _sharedPrefDay.split('-');
      DateTime oldDatetime = DateTime(int.parse(sharedPrefDayParted[0]),
          int.parse(sharedPrefDayParted[1]),
          int.parse(sharedPrefDayParted[2]),
          int.parse(sharedPrefDayParted[3]),
          int.parse(sharedPrefDayParted[4]));
      if(DateTime.now().difference(oldDatetime) >= Duration(days: 4)){
      //  print('pashmz');
       // print('im in the if');
       await myNotification.initializing();
       await myNotification.notificationAfterFewSeconds(_sharedPrefData);
      await  _saveSharedPrefs(myDay: getStandardTime());
      }
    dbHelperReal = DbHelperReal();
    await dbHelperReal
        .getCount('firstplace')
        .then((value) {
      numberOfWordsInEachPlace[0] = value;
        // print("$value the value");
    });
    await dbHelperReal
        .getCount('secondplace')
        .then((value) => numberOfWordsInEachPlace[1] = value);
    await dbHelperReal
        .getCount('thirdplace')
        .then((value) => numberOfWordsInEachPlace[2] = value);
    await dbHelperReal
        .getCount('fourthplace')
        .then((value) => numberOfWordsInEachPlace[3] = value);
    await dbHelperReal
        .getCount('fifthplace')
        .then((value) => numberOfWordsInEachPlace[4] = value);

    if ((numberOfWordsInEachPlace[0] == 0) &&
        (numberOfWordsInEachPlace[1] == 0) &&
        (numberOfWordsInEachPlace[2] == 0) &&
        (numberOfWordsInEachPlace[3] == 0) &&
        (numberOfWordsInEachPlace[4] == 0)){
      await dbHelperReal.resetOnly();
      await dbHelperReal.copyTable();
    }
    tmpPlaceCounter = await dbHelperReal.getCount('tmpplace');
    itemsOfBottomNav = [
      Info(),
      Timing(this.numberOfWordsInEachPlace,this.tmpPlaceCounter),
      StartContinue(),
    ];
    setState(() {
      isGetWholeData = true;
    });
  }
  String getStandardTime(){
    String tmpString = DateFormat.Hm().format(DateTime.now()).replaceAll(':', '-');
    String currentTime = DateFormat('yyyy-MM-dd').format(DateTime.now())+'-' + tmpString;
    return currentTime;
  }
  Future<void> _loadSharedPrefs() async{
 preferences = await SharedPreferences.getInstance();
    if(preferences.getString('time') != null){
     setState(() {
       this._sharedPrefDay = preferences.getString('time');
     });
    }
    if(preferences.getInt('data1') != null){
      setState(() {
        this._sharedPrefData = preferences.getInt('data1');
      });
    }
    if(preferences.getBool('data') != null){
      // print('dakhele if');
      this._sharedDataBase = preferences.getBool('data');
    }
  }
  Future<void> _saveSharedPrefsDataBase(bool myBoolean) async{
    await  SharedPreferences.getInstance().then((value) => value.setBool('data', myBoolean));
  }
  Future<void> _saveSharedPrefs({int myInt,String myDay}) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
   // print('$myInt and $myDay');
    if(myInt != null){
      preferences.setInt('data1', myInt);
    }
    if(myDay != null){
      preferences.setString('time', myDay);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/just_white.jpg',fit: BoxFit.cover,),
        Image.asset('assets/images/icon.png',fit: BoxFit.contain,),
        Scaffold( // rgba(255,238,88 ,1)
          backgroundColor: Colors.transparent,
          drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 140.0,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        /*
                        image: DecorationImage(
                            image: AssetImage('assets/images/beauty.jpg'),
                            fit: BoxFit.cover),
                         */
                        //Colors.blue
                        color: Constants.PRIMARY_COLOR
                      ),
                      child: Text( //'بُمب کُدینگ'  'جیکو(کالوکیشن-آیلتس)'
                        'کاما',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,fontFamily: 'iransans',fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Text('یادآوری مرور',style: TextStyle(fontFamily: 'iransans'),),
                    leading: Icon(Icons.schedule,color: Colors.orangeAccent,),
                    children: [
                      ListTile(
                        title: Text(
                          'هر 3 ساعت',
                          style: TextStyle(fontSize: 10.0,fontFamily: 'iransans'),
                        ),
                        leading: Icon(
                          Icons.remove,
                          color: Colors.blue,
                        ),
                        onTap: (){
                          Navigator.pop(context);
                          setNotification(3);
                        },
                      ),
                      ListTile(
                        title: Text(
                          'هر 6 ساعت',
                          style: TextStyle(fontSize: 10.0,fontFamily: 'iransans'),
                        ),
                        leading: Icon(
                          Icons.remove,
                          color: Colors.blue,
                        ),
                        onTap: (){
                          Navigator.pop(context);
                          setNotification(6);
                        },
                      ),
                      ListTile(
                        title: Text(
                          'هر 12 ساعت',
                          style: TextStyle(fontSize: 10.0,fontFamily: 'iransans'),
                        ),
                        leading: Icon(
                          Icons.remove,
                          color: Colors.blue,
                        ),
                        onTap: (){
                          Navigator.pop(context);
                          setNotification(12);
                        },
                      )
                    ],
                  ),

                  ExpansionTile(
                    title: Text('پشتیبانی',style: TextStyle(fontFamily: 'iransans'),),
                    leading: SvgPicture.asset(
                      'assets/images/support.svg',
                      width: 25.0,
                      height: 25.0,
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          'تماس با پشتیبانی',
                          style: TextStyle(fontSize: 10.0,fontFamily: 'iransans'),
                        ),
                        leading: Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                        onTap: () async{
                          try{

                            await launch("tel:09331500877");
                          }
                          catch(e){
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Icon(
                                    Icons.info,
                                    color: Colors.blue,
                                  ),
                                  content: SelectableText('شماره تماس : 09331500877',style: TextStyle(fontFamily: 'iransans'),),
                                  actions: <Widget>[
                                    FlatButton(
                                        shape: RoundedRectangleBorder(),
                                        color: Colors.blue,
                                        child: Text("باشه",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontFamily: 'iransans')),
                                        onPressed: () async {

                                          Navigator.pop(context);
                                        }),
                                  ],
                                ));
                          }

                        },
                      ),
                      ListTile(
                        title: Text(
                          'ارسال ایمیل به پشتیبانی',
                          style: TextStyle(fontSize: 10.0,fontFamily: 'iransans'),
                        ),
                        leading: Icon(
                          Icons.email,
                          color: Constants.PRIMARY_COLOR,
                        ),
                        onTap: () async{
                          try{
                            await launch("mailto:info@workar.ir?subject=&body=");

                          }
                          catch(e){
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Icon(
                                    Icons.info,
                                    color: Colors.blue,
                                  ),
                                  content: SelectableText('آدرس ایمیل: info@workar.ir',style: TextStyle(fontFamily: 'iransans'),),
                                  actions: <Widget>[
                                    FlatButton(
                                        shape: RoundedRectangleBorder(),
                                        color: Colors.blue,
                                        child: Text("باشه",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontFamily: 'iransans')),
                                        onPressed: () async {

                                          Navigator.pop(context);
                                        }),
                                  ],
                                ));
                          }
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text(
                      'حامی برنامه',
                      style: TextStyle(fontSize: 10.0,fontFamily: 'iransans'),
                    ),
                    leading: Icon(
                      Icons.flag,
                      color: Constants.PRIMARY_COLOR,
                    ),
                    onTap: () async{
                      try{
                        await launch("https://Snoble.me/");
                      }
                      catch(e){
                       print('ops!');
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      'آموزش برنامه',
                      style: TextStyle(fontSize: 10.0,fontFamily: 'iransans'),
                    ),
                    leading: Icon(
                      Icons.help,
                      color: Constants.PRIMARY_COLOR,
                    ),
                    onTap: () async{
                      try{
                        await launch("https://workar.ir/language-teaching/");
                      }
                      catch(e){
                        print('ops!');
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      'گواهینامه',
                      style: TextStyle(fontSize: 10.0,fontFamily: 'iransans'),
                    ),
                    leading: Icon(
                      Icons.verified_user,
                      color: Colors.lightGreen,
                    ),
                    onTap: () async{ //69a7864a-cebf-11e8-96cf-005056a205be

                      try{
                        await launch("https://workar.ir/certificate/");
                      }
                      catch(e){
                        print('ops!');
                      }
                    },
                  ),


                  ListTile(//طریق درگاه پرداخت زرین‌پال  کافه‌بازار
                    title: Text('خرید برنامه از طریق کافه‌بازار', style: TextStyle(fontSize: 10.0,fontFamily: 'iransans')),
                    leading: Image.asset('assets/images/bazaar.png',height: 32.0,width: 32.0,),
                    onTap: () async{
                      preferences = await SharedPreferences.getInstance();
                      if(preferences.getBool('purchaseFlow') == false || preferences.getBool('purchaseFlow') == null) {
                        Navigator.pop(context);

                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>PaymentPage()
                        ));

                      }
                      else{
                        showColoredToast(Colors.green, 'برنامه قبلا خریداری شده.');
                      }
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 370.0),
                    child: Center(
                      child: Text(
                        'نسخه 1.0.2',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w100,fontFamily: 'iransans'),
                      ),
                    ),
                  )

                ],
              )),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              title: Text(
                titles[itemIndex],
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w100,fontFamily: 'iransans'),
              ),  //rgba(76,175,80 ,1) Colors.blue[400]
              backgroundColor:Constants.PRIMARY_COLOR,
            ),
          ),
          body: mainReturn(isGetWholeData),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.white10,
            //Colors.blue[400]
            color: Constants.PRIMARY_COLOR,
            height: 50.0,
            animationDuration: Duration(milliseconds: 300),
            items: <Widget>[
              Icon(
                Icons.info_outline,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
              Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.amber,
                child: Icon(
                  Icons.inbox,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
            index: itemIndex,
            onTap: (index) async {
              setState(() {
                itemIndex = index;
              });
            },
          ),
        )
      ],
    );

  }
  void setNotification(int hour) async{
    await   _saveSharedPrefs(myInt: hour);
    // await  _loadSharedPrefs();
    //       print(_sharedPrefData);
    await myNotification.initializing();
    showColoredToast(Colors.orangeAccent, 'لطفا صبر کنید ...');
    await myNotification.notificationAfterFewSeconds(hour);
    showColoredToast(Color.fromRGBO(0,200,83, 1.0), 'انجام شد');
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


  mainReturn(value) {
    if (value) {
     // print('value');
       return Center(
        child: itemsOfBottomNav[itemIndex],
      );
    } else {
    //  print('not value');
      return Center(child: CircularProgressIndicator());
    }
  }
}
