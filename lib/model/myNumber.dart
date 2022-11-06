class MyNumber{
  int _id;
  int _number;

  int get number => _number;

  set number(int value) {
    _number = value;
  }

  MyNumber(this._number);
  MyNumber.withID(this._id,this._number);


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['number'] = this._number;
    if(_id != null){
      map['id'] = this._id;
    }
    return map;
  }

  MyNumber.fromObject(dynamic object){
    this._id = object['id'];
    this._number = object['number'];
  }
}