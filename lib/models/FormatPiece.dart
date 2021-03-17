class FormatPiece {

  int _id ;
  String _piece ;
  String _format ;
  int _currentindex ;
  String _year ;

  FormatPiece(this._id, this._piece, this._format, this._currentindex , this._year);

  FormatPiece.init();

  FormatPiece.fromMap(dynamic map){
    this._id = map["id"];
    this._piece=map["Piece"];
    this._format=map["Format"];
    this._currentindex = map["Current_index"];
    this._year = map["Year"] ;
  }

  Map<String ,dynamic> toMap(){
    var map = new Map<String, dynamic>();

    map["Piece"] = this._piece;
    map["Format"]=this._format;
    map["Current_index"]=this._currentindex;
    map["Year"] = this._year ;

    return map ;
  }

  String get year => _year;

  set year(String value) {
    _year = value;
  }

  int get currentindex => _currentindex;

  set currentindex(int value) {
    _currentindex = value;
  }

  String get format => _format;

  set format(String value) {
    _format = value;
  }

  String get piece => _piece;

  set piece(String value) {
    _piece = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'FormatPiece{_id: $_id, _piece: $_piece, _format: $_format, _currentindex: $_currentindex}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormatPiece &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}