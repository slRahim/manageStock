

class CompteTresorie {
  int _id ;
  String _numCompte,_nomCompte, _codeCompte ;
  double _soldeDepart , _solde ;

  CompteTresorie(this._id, this._numCompte, this._nomCompte, this._codeCompte,
      this._soldeDepart, this._solde);

  CompteTresorie.init();

  CompteTresorie.fromMap(dynamic obj){
    this._id = obj["id"];
    this._numCompte = obj["Num_compte"];
    this._nomCompte = obj["Nom_compte"];
    this._codeCompte = obj["Code_compte"];
    this._solde = obj["Solde"];
    this._soldeDepart = obj["Solde_depart"];
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> obj = new Map<String,dynamic>();
    obj["id"]=this._id ;
    obj["Num_compte"]=this._numCompte ;
    obj["Nom_compte"]=this._nomCompte  ;
    obj["Code_compte"]=this._codeCompte ;
    obj["Solde"]=this._solde;
    obj["Solde_depart"]=this._soldeDepart;

    return obj ;
  }

  get solde => _solde;

  set solde(value) {
    _solde = value;
  }

  double get soldeDepart => _soldeDepart;

  set soldeDepart(double value) {
    _soldeDepart = value;
  }

  get codeCompte => _codeCompte;

  set codeCompte(value) {
    _codeCompte = value;
  }

  get nomCompte => _nomCompte;

  set nomCompte(value) {
    _nomCompte = value;
  }

  String get numCompte => _numCompte;

  set numCompte(String value) {
    _numCompte = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'CompteTresorie{_id: $_id, _numCompte: $_numCompte, _nomCompte: $_nomCompte, _codeCompte: $_codeCompte, _soldeDepart: $_soldeDepart, _solde: $_solde}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompteTresorie &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}