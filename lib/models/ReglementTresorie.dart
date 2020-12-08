

class ReglementTresorie {

  int _id ;
  int _tresorie_id ;
  int _piece_id ;
  double _regler ;

  ReglementTresorie.init();

  ReglementTresorie(this._id, this._tresorie_id, this._piece_id, this._regler);

  ReglementTresorie.fromMap(dynamic obj){
    this._id = obj["id"];
    this._tresorie_id=obj["Tresorie_id"];
    this._piece_id=obj["Piece_id"];
    this._regler = obj["Regler"];
  }

  Map<String , dynamic> toMap(){
    Map<String , dynamic> map = new Map<String , dynamic>();

    map["Tresorie_id"] = this._tresorie_id;
    map["Piece_id"]= this._piece_id;
    map["Regler"] = this._regler ;

    return  map ;
  }


  int get piece_id => _piece_id;

  set piece_id(int value) {
    _piece_id = value;
  }

  int get tresorie_id => _tresorie_id;

  set tresorie_id(int value) {
    _tresorie_id = value;
  }

  double get regler => _regler;

  set regler(double value) {
    _regler = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'ReglementTresorie{_id: $_id, tier_id: $_tresorie_id, piece_id: $_piece_id, _regler: $_regler}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReglementTresorie &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}