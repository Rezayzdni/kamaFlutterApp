//import 'dart:async';
//import 'package:flutter/services.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:uni_links/uni_links.dart';
//import 'package:zarinpal/zarinpal.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter/material.dart';
//
//
//class ZarinPay extends StatefulWidget {
//  @override
//  _ZarinPayState createState() => _ZarinPayState();
//}
//
//class _ZarinPayState extends State<ZarinPay> {
//  PaymentRequest _paymentRequest = PaymentRequest();
//  String _paymentUrl;
//  StreamSubscription _sub;
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    initUniLinks();
//    configZarinPayment();
//    startZarinPayment();
//
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Center(
//            child: Text( //'بُمب کُدینگ'  'جیکو(کالوکیشن-آیلتس)'
//              "در حال انتقال به درگاه پرداخت زرین‌پال...",
//              textAlign: TextAlign.center,
//              style: TextStyle(
//                  color: Colors.amberAccent,fontFamily: 'iransans',fontSize: 20.0,fontWeight: FontWeight.bold
//              ),
//            ),
//          ),
//          Padding(padding: EdgeInsets.only(top: 15.0),),
//          Image.asset('assets/images/zarin.png',height: 32.0,width: 32.0,)
//        ],
//      ),),
//    );
//  }
//  Future<Null> initUniLinks() async{
//
//    try{
//      _sub = getLinksStream().listen((event){
//        var uri = Uri.parse(event);
//        var list = uri.queryParametersAll.entries.toList();
//        zarinPaymentVerification(list[1].value[0], list[0].value[0]);
//        Navigator.pop(context);
//
//      },onError: (err){
//        showColoredToast(Colors.red, 'خطا در فرآیند پرداخت! لطفا دوباره امتحان کنید.');
//        Navigator.pop(context);
//
//      });
//
//    }
//    on PlatformException{
//      showColoredToast(Colors.red, 'خطا در فرآیند پرداخت! لطفا دوباره امتحان کنید.');
//      Navigator.pop(context);
//    }
//    catch(e){
//      showColoredToast(Colors.red, 'خطا در فرآیند پرداخت! لطفا دوباره امتحان کنید.');
//      Navigator.pop(context);
//    }
//
//  }
//  void configZarinPayment(){
//    _paymentRequest
//      ..setIsSandBox(false) // if your application is in developer mode, then set the sandBox as True otherwise set sandBox as false
//      ..setMerchantID("69a7864a-cebf-11e8-96cf-005056a205be")
//      ..setAmount(35000)
//      ..setCallbackURL("commarefresh://commarefresh.x") //The callback can be an android scheme or a website URL, you and can pass any data with The callback for both scheme and  URL
//      ..setDescription("دسترسی به بخش پرمیوم برنامه کاما");
//  }
//
//  Future<void> startZarinPayment() async{
//
//    ZarinPal().startPayment(_paymentRequest, (int status, String paymentGatewayUri) async{
//      if(status == 100){
//        _paymentUrl  = paymentGatewayUri;
//        var isDoneUrl =   await launch(_paymentUrl);
//        if(isDoneUrl) {
//          showColoredToast(Colors.green, 'ایجاد درخواست پرداخت...');
//        }
//        else {
//          showColoredToast(Colors.red, 'خطا در ایجاد درخواست پرداخت!');
//          Navigator.pop(context);
//        }
//
//      }
//      else{
//        showColoredToast(Colors.red, 'لطفا اتصال اینترنت رو چک کنید.');
//        Navigator.pop(context);
//      }
//    });
//  }
//
//  void zarinPaymentVerification(String zarinPaymentStatus , String zarinPaymentAuthority){
//    ZarinPal().verificationPayment(zarinPaymentStatus, zarinPaymentAuthority, _paymentRequest, (isPaymentSuccess,refID, paymentRequest){
//      if(isPaymentSuccess){
//        _savePurchaseFlow(true);
//        showColoredToast(Colors.green, 'پرداخت شما با موفقیت انجام شد.');
//      }
//      else{
//        showColoredToast(Colors.red, 'فرآیند پرداخت با خطا مواجه شد.');
//      }
//
//    });
//  }
//  void showColoredToast(Color color, String text) {
//    Fluttertoast.showToast(
//      msg: text,
//      gravity: ToastGravity.BOTTOM,
//      toastLength: Toast.LENGTH_LONG,
//      backgroundColor: color,
//      textColor: Colors.white,
//    );
//  }
//  Future<void> _savePurchaseFlow(bool purchaseComplete) async{
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    // print('$myInt and $myDay');
//    preferences.setBool('purchaseFlow',purchaseComplete);
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    _sub.cancel();
//    super.dispose();
//  }
//}
