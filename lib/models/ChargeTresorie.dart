
class ChargeTresorie {

  int _id ;
  String _libelle ;

  ChargeTresorie(this._id, this._libelle);

  ChargeTresorie.init();

  ChargeTresorie.fromMap(dynamic obj){
    this._id = obj["id"];
    this._libelle = obj["Libelle"];

  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> obj = new  Map<String,dynamic>();
    obj["id"]=this._id ;
    obj["Libelle"]=this._libelle;

    return obj ;
  }

  String get libelle => _libelle;

  set libelle(String value) {
    _libelle = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'ChargeTresorie{_id: $_id, _libelle: $_libelle}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargeTresorie &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}