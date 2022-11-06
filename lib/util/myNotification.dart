import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import 'package:comma/main.dart';
class MyNotification{
 // MyNotification(this.time);
  //final int time;
  BuildContext context;
  final flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
 // IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  //  initializing();
   // notificationAfterFewSeconds();


  Future<void> initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');

    initializationSettings = InitializationSettings(
        androidInitializationSettings, null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

  }

  Future<void> notificationAfterFewSeconds(int time) async {


    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'third Channel ID', 'third Channel title', 'third channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'ticker0',
    enableVibration: true,);

   // IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, null);
    if(time == 12){
     await flutterLocalNotificationsPlugin.cancelAll();//'بُمب کُدینگ'  جیکو(کالوکیشن-آیلتس)
      for(int i = 1 ; i<=30 ; i++){
        await flutterLocalNotificationsPlugin.schedule(i, 'کاما', 'مرور کارت‌ها یادت نره!',DateTime.now().add(Duration(hours:12*i)), notificationDetails);
      }

    }
    else if(time == 6){
     await flutterLocalNotificationsPlugin.cancelAll();
      for(int i = 1 ; i<=60 ; i++){
        await flutterLocalNotificationsPlugin.schedule(i, 'کاما', 'مرور کارت‌ها یادت نره!',DateTime.now().add(Duration(hours:6*i)), notificationDetails);
      }
    }
    else if(time == 3){
     await flutterLocalNotificationsPlugin.cancelAll();
      for(int i = 1 ; i<=120 ; i++){
        await flutterLocalNotificationsPlugin.schedule(i, 'کاما', 'مرور کارت‌ها یادت نره!',DateTime.now().add(Duration(hours:3*i)), notificationDetails);
      }
    }

  }

  Future<void> onSelectNotification(String payLoad) async{
    if (payLoad != null) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => MyApp()
      ));
    }

  }


}


