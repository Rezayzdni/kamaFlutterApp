class MyTime{
  int _id;
  String _time;

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  MyTime(this._time);
  MyTime.withID(this._id,this._time);


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['time'] = this._time;
    if(_id != null){
      map['id'] = this._id;
    }
    return map;
  }

  MyTime.fromObject(dynamic object){
    this._id = object['id'];
    this._time = object['time'];
  }
}