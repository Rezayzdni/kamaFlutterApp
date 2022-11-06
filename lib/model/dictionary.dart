class Dictionary{
  int _id;
  String _en;
  String _fa;
  int _cardTime;




  Dictionary(this._en,this._fa,this._cardTime);
  Dictionary.withID(this._id,this._en,this._fa,this._cardTime);

  int get cardTime => _cardTime;

  set cardTime(int value) {
    _cardTime = value;
  }
  String get fa => _fa;

  set fa(String value) {
    _fa = value;
  }

  String get en => _en;

  set en(String value) {
    _en = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['en'] = this._en;
    map['fa'] = this._fa;
    map['cardtime'] = this._cardTime;
    if(_id != null){
      map['id'] = this._id;
    }
    return map;
  }

  Dictionary.fromObject(dynamic object){
    this._id = object['id'];
    this._en = object['en'];
    this._fa = object['fa'];
    this._cardTime = object['cardtime'];

  }
}