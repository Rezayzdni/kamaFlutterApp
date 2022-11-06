
import 'package:flutter/material.dart';
import 'package:comma/ui/mainPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:najvaflutter/najvaflutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  NajvaFlutter najva = NajvaFlutter();
  najva.setFirebaseEnabled(false); // set true if your app using firebase beside najva.
  najva.init("c71f846c-9068-4f55-9943-0c166ea5201b", 20959);

  runApp(MyApp());
}
//flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi

//flutter build apk --target-platform android-arm,android-arm64
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("fa", "IR"),
      ],
      locale: Locale("fa", "IR"),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
/*
<intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="commarefresh"
                      android:host="commarefresh.x" />
            </intent-filter>
 */
