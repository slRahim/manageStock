

class DefaultPrinter {

  int _id ;
  String _adress ;
  String _name ;
  int _type ;


  DefaultPrinter.init();

  DefaultPrinter(this._id, this._adress, this._name, this._type);

  DefaultPrinter.fromMap(dynamic obj){
    this._id = obj['id'];
    this._adress = obj['Adress'];
    this._name = obj['Name'];
    this._type = obj['Type'];
  }

  Map<String , dynamic> toMap(){
    Map<String , dynamic> obj = new Map<String , dynamic> ();
    obj['Adress']=this._adress;
    obj['Name']=this._name ;
    obj['Type']=this._type ;

    return obj ;
  }

  int get type => _type;

  set type(int value) {
    _type = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get adress => _adress;

  set adress(String value) {
    _adress = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'DefaultPrinter{_id: $_id, _adress: $_adress, _name: $_name, _type: $_type}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefaultPrinter &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}