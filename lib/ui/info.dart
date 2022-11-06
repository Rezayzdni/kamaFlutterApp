import 'package:comma/util/consts.dart';
import 'package:flutter/material.dart';
class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Opacity(
          opacity: 0.9,
          child: Container(
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 8.5,
                        offset: Offset(0.5, 2.0),
                        color: Colors.black45)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'بنام خدای زیبایی ها که سرآغاز آغازهاست،به نام آن والایی که زینت زبانها و یادگار جانهاست. سلامی سرشار ازعطر گل یاس در لفافه ای از محبت و عشق،پیشکش حضورسبز پر لطفتان.از اینکه توفیق رفیق گشت و سعادت مساعدت نمود تا سخنی صمیمانه با شما خوانندگان فهیم و فرزانه داشته باشیم آن بزرگ یگانه هستی را شاکریم و امید برآن داریم تا محتوائی درخور دیدگان باارزشتان مهیا سازیم،از همراهی شما سپاسگزاریم،معرف ما به دوستانتان باشید.\n',
                      style: TextStyle(fontSize: 15.0,fontFamily: 'iransans',color: Colors.green,fontWeight: FontWeight.w500)
                  ),
                 // Text('\n'),
                  Text('محتوای این برنامه توسط تیم تولید محتوا و برنامه نویسی وبسایت ورکار (شرکت زرّین فکران فرهوش) مهیا و در دسترس شما بزرگواران قرار گرفته است.\n',
                      style: TextStyle(fontSize: 15.0,fontFamily: 'iransans',color: Colors.blue,fontWeight: FontWeight.w300)
                  ),
                  Text(
                    'این مجموعه از سوی کمپانی ETS در شش سطح از کاملا مقدماتی تا کاملا پیشرفته می باشد. شما در این مجموعه هر آنچه که برای یادگیری زبان انگلیسی نیاز است را فرا خواهید گرفت. همچنين اين مجموعه توسط موسسه ETS (خدمات آزمون هاي آموزشي) به عنوان يکي از معتبرترين روش هاي آموزشي جهت آمادگي در آزمون تافل انتخاب شده و استفاده از آن برای دانشجوياني که قصد تحصيل در دانشگاه هاي آمريکايي و اروپايي را دارند و حتي کساني که براي کار و تجارت به کشورهاي آمريکايي و اروپايي سفر مي کنند، بسیار مفید خواهد بود.',
                    style: TextStyle(fontSize: 15.0, color: Constants.PRIMARY_COLOR,fontFamily: 'iransans',fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}

