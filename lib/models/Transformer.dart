
class Transformer {

  int _id ;
  int _oldPieceId , _newPieceId , _oldMov;

  Transformer.init();

  Transformer(this._id, this._oldPieceId, this._newPieceId, this._oldMov);

  Transformer.fromMap(dynamic obj){
    this._id = obj["id"];
    this._oldMov=obj["Old_Mov"];
    this._oldPieceId=obj["Old_Piece_id"];
    this._newPieceId = obj["New_Piece_id"];
  }

  Map<String , dynamic> toMap(){
    Map<String , dynamic> map = new Map<String , dynamic>();

    map["Old_Mov"] =this._oldMov;
    map["Old_Piece_id"] =this._oldPieceId;
    map["New_Piece_id"]=this._newPieceId ;

    return map ;
  }

  get oldMov => _oldMov;

  set oldMov(value) {
    _oldMov = value;
  }

  get newPieceId => _newPieceId;

  set newPieceId(value) {
    _newPieceId = value;
  }

  int get oldPieceId => _oldPieceId;

  set oldPieceId(int value) {
    _oldPieceId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'Transformer{_id: $_id, _oldPieceId: $_oldPieceId, _newPieceId: $_newPieceId, _oldMov: $_oldMov}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transformer &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}