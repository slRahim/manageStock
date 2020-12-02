
class TresorieCategories {
  int _id;
  String _libelle;

  TresorieCategories.init();

  TresorieCategories(this._id, this._libelle);

  TresorieCategories.fromMap(dynamic obj){
    this._id  = obj["id"];
    this._libelle = obj ["Libelle"];
  }

  Map<String , dynamic> toMap(){
    Map<String , dynamic> map = new Map<String , dynamic>();

    map["Libelle"]= this._libelle;

    return map ;
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
    return 'TresorieCategories{_id: $_id, _libelle: $_libelle}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TresorieCategories &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}