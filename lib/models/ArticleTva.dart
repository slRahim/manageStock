



class ArticleTva {
  double _tva;
  
  double get tva=> _tva;
  
  void setTva(double tva) {
    this._tva=tva;
  }

  ArticleTva(this._tva);

  ArticleTva.fromMap(dynamic obj) {
    this._tva = obj["Tva"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["Tva"] = _tva;
    return map;
  }


  @override
  String toString() {
    return 'ArticleTva{_tva: $_tva}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleTva && runtimeType == other.runtimeType && _tva == other._tva;

  @override
  int get hashCode => _tva.hashCode;
}