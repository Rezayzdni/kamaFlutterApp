import 'package:comma/util/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flip_card/flip_card.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:comma/model/dictionary.dart';
import 'package:comma/util/myExistingDB.dart';


import 'mainPage.dart';

class ShowFlips extends StatefulWidget {
  ShowFlips({this.customDictionaryList, this.tableIndex, this.obsRev});
  // final int listElement;
  final List<dynamic> customDictionaryList;
  // final int observationRevision;
  final int tableIndex;
  final int obsRev;
  @override
  _ShowFlipsState createState() => _ShowFlipsState(this.customDictionaryList);
}

class _ShowFlipsState extends State<ShowFlips>
    with SingleTickerProviderStateMixin {
  _ShowFlipsState(this.customDictionaryList);
  List<dynamic> customDictionaryList;
  List<String> tables;
  int wordListIndex;


  double tmpPercent;
  //DbHelper dbHelper;
  DbHelperReal dbHelperReal;
  // double percent;
//  List<dynamic> mainDictionaryList;
  bool mustForward;
  //bool end;

  int youCanPassIfResultIsZero;
  bool isDoneRefresh;
  bool theLast;
  // List<dynamic> customDictionaryList;
  num posX = 30.0;
  num posY = 30.0;
  num posFulX = 335.0;
  num posFulY = 310.0;
  String myFront;
  String myBack;
  bool itIsTheLast;
  List<int> variances;
  bool ifeBad;
  Animation<double> animation;
  AnimationController controller;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  @override
  void initState() {
    super.initState();
    // customDictionaryList = List<dynamic>();
    ifeBad = false;
    // divisor = 0.0;
    variances = [1, 2, 4, 8, 15];
    isDoneRefresh = false;
    // tmpWordListIndex = 0;
    tables = [
      'firstplace',
      'secondplace',
      'thirdplace',
      'fourthplace',
      'fifthplace'
    ];
    tmpPercent = 0.0;
    wordListIndex = 0;
    youCanPassIfResultIsZero = -1;
    mustForward = false;
    // dbHelper = DbHelper();
    dbHelperReal = DbHelperReal();
    myFront = '';
    myBack = '';
    controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    theLast = false;
    itIsTheLast = false;
    isDoneRefresh = true;
    controller.addListener(() {
      if (isDoneRefresh) {
        setState(() {
          posX = posFulX * animation.value + 30;
          posY = posFulY * animation.value + 30;
          myFront =
              Dictionary.fromObject(this.customDictionaryList[wordListIndex])
                  .en;
          if (posX == 30.0 && mustForward) {
            controller.forward();
          }
        });
      }
    });
    controller.forward();
  }
 
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'مرور کارت‌ها',
            style: TextStyle(fontFamily: 'iransans'),
          ),
          backgroundColor: Constants.PRIMARY_COLOR,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: returnSthDifferent(isDoneRefresh, context),
      ),
    );
  }

  returnSthDifferent(value, context) {
    if (value) {
      return ListView(children: <Widget>[myColumn(context)]);
    } else if (!value) {
      return Center(child: CircularProgressIndicator());
    }
  }

  splitForMe(String string) {
    var partedTime = string.split('-');
    return partedTime;
  }

  myColumn(context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 110),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Shimmer.fromColors(
            //Color.fromRGBO(193,17,105, 1.0)
            baseColor: Colors.white,
            highlightColor: Constants.PRIMARY_COLOR,
            child: Text(
              '${wordListIndex + 1} / ${customDictionaryList.length}',
              style: TextStyle(fontFamily: 'iransans'),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white30,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 8.5,
                  offset: Offset(0.5, 2.0),
                  color: Constants.SECONDARY_COLOR,
                )
              ]),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 28),
        ),
        tiredButton(context),
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 26),
        ),
        myCard(),
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 26),
        ),
        canShowButtons(context),
      ],
    );
  }

  void theEnd() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  String getStandardTime() {
    String tmpString =
        DateFormat.Hm().format(DateTime.now()).replaceAll(':', '-');
    String currentTime =
        DateFormat('yyyy-MM-dd').format(DateTime.now()) + '-' + tmpString;
    return currentTime.replaceAll('-', '');
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

  myCard() {
    return Container(
      width: posX,
      height: posY,
      child: Card(
        elevation: 0.0,
        child: FlipCard(
          key: cardKey,
          direction: FlipDirection.HORIZONTAL,
          speed: 400,
          flipOnTouch: !itIsTheLast,
          onFlipDone: (status) => canFlip(status),
          front: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                //Colors.blue[500]
                color: Constants.SECONDARY_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 4.5,
                    offset: Offset(0.5, 2.0),
                    color: Constants.SECONDARY_COLOR,
                  )
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      //myFront.contains('(') ? myFront.replaceAll('(', '') + ')'.trim() :
                      myFront.trim(),
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'iransans'),
                    ),
                  ),
                ),
                showMeRemove(),
              ],
            ),
          ),
          back: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                //Color.fromRGBO(0, 230, 118, 1.0)
                color: Constants.PRIMARY_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(3.5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 6.5,
                      offset:
                          Offset(0.5, 2.0), //Color.fromRGBO(193,17,105, 1.0)
                      color: Constants.PRIMARY_COLOR)
                ]),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,//string.replace(/  +/g, ' ')
                      child: Text(myBack,
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'iransans')),
                    ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showMeRemove() {
    if (widget.obsRev == 1) {
      return Container();
    } else {
      return Expanded(
        flex: 1,
        child: FlatButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Icon(
                      Icons.warning,
                      color: Colors.amberAccent,
                    ),
                    content: Text(
                      'کارت جزء مرور نشده‌ها بشه؟',
                      style: TextStyle(fontFamily: 'iransans'),
                    ),
                    actions: <Widget>[
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                              shape: RoundedRectangleBorder(),
                              color: Colors.red,
                              child: Text("آره",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontFamily: 'iransans')),
                              onPressed: () async {
                                Navigator.pop(context);
                                String tmpTable;
                                await dbHelperReal.deleteWord(
                                    Dictionary.fromObject(
                                            this.customDictionaryList[
                                                wordListIndex])
                                        .id,
                                    tables[widget.tableIndex]);
                                tmpTable = 'tmpplace';

                                await dbHelperReal.insertWord(
                                    Dictionary(
                                        Dictionary.fromObject(
                                                this.customDictionaryList[
                                                    wordListIndex])
                                            .en,
                                        Dictionary.fromObject(
                                                this.customDictionaryList[
                                                    wordListIndex])
                                            .fa,
                                        null),
                                    tmpTable);

                                //  print('tmp int is : $tmpInt');
                                setState(() {
                                  youCanPassIfResultIsZero = -1;
                                  this
                                      .customDictionaryList
                                      .removeAt(wordListIndex);
                                });

                                if ((this.customDictionaryList.length == 0) &&
                                    (wordListIndex == 0)) {
                                  ifeBad = true;
                                } else if (wordListIndex == 0) {
                                  setState(() {
                                    controller.reverse();
                                    mustForward = true;
                                  });
                                } else if (wordListIndex != 0) {
                                  //   print('ife 3');
                                  setState(() {
                                    wordListIndex--;
                                    controller.reverse();
                                    mustForward = true;
                                  });
                                }
                                if (ifeBad) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainPage(),
                                      ));
                                }
                              }),
                          FlatButton(
                            shape: RoundedRectangleBorder(),
                            color: Colors.blue,
                            child: Text('نه',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontFamily: 'iransans')),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ],
                  ));
            },
            shape: CircleBorder(),
            child: Icon(
              Icons.remove_circle,
              color: Colors.white,
            )),
      );
    }
  }
  canFlip(status) {
    setState(() {
      if (!status) {
        myBack = '';
        myBack =
            Dictionary.fromObject(this.customDictionaryList[wordListIndex]).fa;
        youCanPassIfResultIsZero = 0;
      } else {
        // if(youCanPassIfResultIsZero < 1)
        myBack = '';
        youCanPassIfResultIsZero = -1;
      }
      //   print('you can $youCanPassIfResultIsZero');
    });
  }

  canShowButtons(context) {
    if (youCanPassIfResultIsZero == 0) {
      if (widget.obsRev == 0) {
        return myButtons(
            //Color.fromRGBO(0, 230, 118, 1.0)
            'بعدی',
            'قبلی',
            Constants.PRIMARY_COLOR,
            Constants.SECONDARY_COLOR);
      } else {
        return myButtons(
            // Color.fromRGBO(0, 230, 118, 1.0)
            'بلدم',
            'بلد نیستم',
            Color.fromRGBO(0, 200, 83, 1.0),
            Colors.red);
      }
    } else {
      return Container();
    }
  }

  Future<void> insertWordToDB(Dictionary dictionary, index) async {
    // print('to insert hastm va meqdare table : ${await dbHelperReal.getWords(tables[index])}');

    if (index != 5) {
      await dbHelperReal.insertWord(dictionary, tables[index]);
    }
  }

  Future<void> deleteWordFromDB(int id, int index) async {
    await dbHelperReal.deleteWord(id, tables[index]);
  }

  myButtons(String firstText, String secondText, Color firstColor,
      Color secondColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        //blue button
        Container(
          width: 120.0,
          decoration: BoxDecoration(
              color: firstColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 8.5,
                    offset: Offset(0.5, 2.0),
                    color: firstColor)
              ]),
          child: MaterialButton(
            child: Text(
              firstText,
              style: TextStyle(fontFamily: 'iransans', color: Colors.white),
            ),
            onPressed: () async {
              cardKey.currentState.toggleCard();
              if (widget.obsRev == 1) {
                Dictionary oneInstanceOfDictionary = Dictionary.fromObject(
                    this.customDictionaryList[wordListIndex]);
                oneInstanceOfDictionary.cardTime = int.parse(getStandardTime());

                await insertWordToDB(
                    oneInstanceOfDictionary, widget.tableIndex + 1);
                await deleteWordFromDB(
                    oneInstanceOfDictionary.id, widget.tableIndex);
              }
              setState(() {
                youCanPassIfResultIsZero = -1;
                if (wordListIndex + 1 != this.customDictionaryList.length) {
                  wordListIndex++;
                  controller.reverse();

                  mustForward = true;
                } else {
                  itIsTheLast = true;
                }
              });
              if (itIsTheLast && widget.obsRev == 0) {
                showColoredToast(Colors.green, 'تموم شد!');
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ));
              } else if (itIsTheLast && widget.obsRev == 1) {
                showColoredToast(Colors.green, 'تموم شد!');
                theEnd();
              }
            },
          ),
        ),
        //red button
        Container(
          width: 120.0,
          decoration: BoxDecoration(
              color: secondColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 8.5,
                    offset: Offset(0.5, 2.0),
                    color: secondColor)
              ]),
          child: MaterialButton(
            child: Text(
              secondText,
              style: TextStyle(fontFamily: 'iransans', color: Colors.white),
            ),
            onPressed: () async {
              cardKey.currentState.toggleCard();
              if (widget.obsRev == 1) {
                Dictionary oneInstanceOfDictionary = Dictionary.fromObject(
                    this.customDictionaryList[wordListIndex]);
                oneInstanceOfDictionary.cardTime = int.parse(getStandardTime());

                await deleteWordFromDB(
                    oneInstanceOfDictionary.id, widget.tableIndex);
                await insertWordToDB(oneInstanceOfDictionary, 0);
              }
              setState(() {
                youCanPassIfResultIsZero = -1;
                if (widget.obsRev == 0) {
                  if (wordListIndex != 0) {
                    wordListIndex--;
                    controller.reverse();

                    mustForward = true;
                  }
                } else if (widget.obsRev == 1) {
                  if (wordListIndex + 1 != this.customDictionaryList.length) {
                    wordListIndex++;
                    controller.reverse();

                    mustForward = true;
                  } else {
                    itIsTheLast = true;
                  }
                }
              });
              if (itIsTheLast) {
                showColoredToast(Colors.green, 'تموم شد!');
                theEnd();
              }
            },
          ),
        ),
      ],
    );
  }

  tiredButton(context) {
    //print('my $youCanPassIfResultIsZero');
    if (!itIsTheLast) {
      return Container(
        width: 360.0,
        decoration: BoxDecoration(
            color: Constants.PRIMARY_COLOR,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  blurRadius: 8.5,
                  offset: Offset(0.5, 2.0), //.blue[400]
                  color: Constants.PRIMARY_COLOR)
            ]),
        child: MaterialButton(
          child: Text(
            'کافیه!',
            style: TextStyle(color: Colors.white, fontFamily: 'iransans'),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(),
                ));
            // }
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
