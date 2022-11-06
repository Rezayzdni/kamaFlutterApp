import 'dart:convert';
import 'dart:math';
import 'package:cafebazaar_market/cafebazaar_market.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<_PaymentPageState> _myWidgetState = GlobalKey<_PaymentPageState>();
  List<String> encryption = ['a','Z','/','+','b','w','3','5','7','W','i','o','p','c','x',
    'X','D','U','u','f','+','F','s','S','Q','=','e','R','E','/','y','2'];
  Random random = Random();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<bool> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    bool result = await CafebazaarMarket.initPay(
        rsaKey: "MIHNMA0GCSqGSIb3DQEBAQUAA4G7ADCBtwKBrwDN4ddGJNLemzYooDCqrndnTBtezwE4gCnNq9l6olMipq7rIsGdMUrtMKZtmtzK0LFOl9/Pae/FkzHq39f7jKRQA8rD5BMgbeea4Jn/lPz0/w4jW49zWq8Jle/crDKFugV5xYo7CR3nc9wlKoJ9LTXdGMUHkOPOitmcT2oQMuT5kvXE0tNYJsarJHAF8kGLW05bL/Yyxr1m9ERzZNuGGUhs76INNMhR9uwGC9Kl7I8CAwEAAQ==");

    if (!mounted) return false;

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: initPlatformState(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if(_myWidgetState.currentContext != null){
              Navigator.pop(context);
            }
            children = <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16,bottom: 20),
                child: Text('اتصال موفقیت آمیز به سرور کافه‌بازار', style: TextStyle(fontSize: 18.0,fontFamily: 'iransans')),
              ),
              Container(
                width: 200.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)),
                  color: Colors.white,
                  textColor: Colors.green,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () async{
                    await  startPurchase();
                  },
                  child: Text('ادامه خرید', style: TextStyle(fontSize: 12.0,fontFamily: 'iransans')),
                ),
              ),

            ];

          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16,bottom: 20),
                child: Text('لطفا مطمئن بشید که کافه‌بازار رو نصب دارید.', style: TextStyle(fontSize: 18.0,fontFamily: 'iransans')),
              ),
              Container(
                width: 200,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  color: Colors.white,
                  textColor: Colors.red,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('بازگشت', style: TextStyle(fontSize: 12.0,fontFamily: 'iransans')),
                ),
              ),

            ];
          }
          else{
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child:
                Text('لطفا صبر کنید...', style: TextStyle(fontSize: 18.0,fontFamily: 'iransans')),
              )
            ];
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    CafebazaarMarket.disposePayment();
  }

  Future<void> startPurchase() async{
    var payload = generateRandomPayload();
    Map<String, dynamic> result =
    await CafebazaarMarket.launchPurchaseFlow(
        sku: "NewComma",
        consumption: false,
        payload:
        payload);

    try {
      Map valueMap = json.decode(result["purchase"]);
      var payloadFromBazaar = valueMap["developerPayload"].toString();

      if ((result["isSuccess"].toString().trim() == "true") &&
          (valueMap["purchaseState"].toString() == "0")) {
        bool isVerified = await CafebazaarMarket.verifyDeveloperPayload(
            payload: payload);
        if (isVerified) {
          showColoredToast(
              Colors.green, "محصول با موفقیت خریداری شد(شده است).");
          _savePurchaseFlow(isVerified);
        }
        else {
          if (payloadFromBazaar.contains("Rezzcomma==%%%")) {
            showColoredToast(
                Colors.green, "محصول با موفقیت خریداری شد(شده است).");
            _savePurchaseFlow(true);
          }
          else {
            showColoredToast(
                Colors.orangeAccent, "امنیت پرداخت تضمین نشده است!");
            _savePurchaseFlow(false);
          }
        }
      }
      else {
        showColoredToast(Colors.red, "فرآیند پرداخت با خطا مواجه شد.error_code_1");
      }
      Navigator.pop(context);
    }
    catch (e) {
      showColoredToast(Colors.red, "error_code_2.فرآیند پرداخت با خطا مواجه شد.");
      Navigator.pop(context);
    }

  }
  String generateRandomPayload(){

    String randomStr = "";
    //print(encryption.length);
    for(int i= 0 ; i< 41 ; i++){
      randomStr += encryption[random.nextInt(28)];
    }
    return randomStr+"Rezzcomma==%%%";
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
  Future<void> _savePurchaseFlow(bool purchaseComplete) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // print('$myInt and $myDay');
    preferences.setBool('purchaseFlow',purchaseComplete);
  }
}
