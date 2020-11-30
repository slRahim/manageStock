
class MyParams {

  int _id ;
  int _tarification ;
  int _tva ;

  MyParams.init();

  MyParams(this._id, this._tarification, this._tva);

  MyParams.frommMap(dynamic map){
    this._id=map["id"];
    this._tarification=map["Tarification"];
    this._tva=map["Tva"];
  }

  Map<String , dynamic> toMap(){
    Map<String , dynamic> map= new  Map<String , dynamic>();

    map["tarification"]=this._tarification;
    map["Tva"] = this._tva;
  }

  int get tva => _tva;

  set tva(int value) {
    _tva = value;
  }

  int get tarification => _tarification;

  set tarification(int value) {
    _tarification = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'MyParams{_id: $_id, _tarification: $_tarification, _tva: $_tva}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyParams && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}