
class TiersFamille{
  TiersFamille.init();

  int _id;
  String _libelle;

  TiersFamille(this._libelle);

  String get libelle => _libelle;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  set libelle(String value) {
    _libelle = value;
  }

  TiersFamille.fromMap(dynamic obj) {
    this._id = obj["id"];
    this._libelle = obj["Libelle"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["Libelle"] = _libelle;
    return map;
  }

  @override
  String toString() {
    return _libelle;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TiersFamille &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}