
class ArticleTva {
  int _id ;
  double _tva;
  
  double get tva=> _tva;
  
  void setTva(double tva) {
    this._tva=tva;
  }

  ArticleTva(this._tva);

  ArticleTva.id(this._id , this._tva);

  set tva(double value) {
    _tva = value;
  }

  ArticleTva.fromMap(dynamic obj) {
    this._id = obj["id"] ;
    this._tva = obj["Tva"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = this._id;
    map["Tva"] = this._tva;
    return map;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return _tva.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleTva && runtimeType == other.runtimeType && _tva == other._tva;

  @override
  int get hashCode => _tva.hashCode;
}